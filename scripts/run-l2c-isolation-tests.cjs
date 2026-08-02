const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const repoRoot = path.join(__dirname, '..');
const timestamp = Date.now();
const tempBaseDir = path.join(process.env.TEMP || 'C:\\Users\\Administrator\\AppData\\Local\\Temp', 'l2c-test-' + timestamp);

console.log('========================================');
console.log('Running L2-C 6-Scenario Real Integrity & Isolation Tests');
console.log('========================================\n');

if (!fs.existsSync(tempBaseDir)) {
  fs.mkdirSync(tempBaseDir, { recursive: true });
}

function collectRelativeFiles(dir, base) {
  const results = [];
  function recurse(currentDir) {
    const list = fs.readdirSync(currentDir);
    for (const item of list) {
      const full = path.join(currentDir, item);
      if (fs.statSync(full).isDirectory()) {
        recurse(full);
      } else {
        results.push(path.relative(base, full).replace(/\\/g, '/'));
      }
    }
  }
  recurse(dir);
  return results.sort();
}

function cleanArtifact(version) {
  const zip = path.join(repoRoot, `artifacts/student-packages/ai-business-prototype-lesson-02-fallback-start-${version}.zip`);
  const sha = zip + '.sha256';
  if (fs.existsSync(zip)) fs.unlinkSync(zip);
  if (fs.existsSync(sha)) fs.unlinkSync(sha);
}

// Ensure old test artifact removed
cleanArtifact('v0.1.0');
cleanArtifact('v0.1.1');
cleanArtifact('v0.1.2');
cleanArtifact('v0.1.3');

// TEST 1: Normal Fallback Package Export
console.log('--> Test 1: Normal Fallback Package Export');
const version1 = 'v0.1.0';
const exportCmd1 = `powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-02-start" -PackageProfile "lesson-02-fallback-start" -Version "${version1}" -SourceRef "HEAD"`;
execSync(exportCmd1, { cwd: repoRoot, stdio: 'inherit' });

const zipPath1 = path.join(repoRoot, `artifacts/student-packages/ai-business-prototype-lesson-02-fallback-start-${version1}.zip`);
const zipShaPath1 = zipPath1 + '.sha256';

if (!fs.existsSync(zipPath1) || !fs.existsSync(zipShaPath1)) {
  throw new Error('Test 1 Failed: Exported fallback ZIP or SHA256 file missing.');
}
console.log('[PASS] Test 1 Passed: Normal Fallback Package Exported Successfully.');

// TEST 2: Unpack & Inspect Overlay Application & Build Verification
console.log('\n--> Test 2: Unpacking Fallback Package & Closed-Set Verification');
const unzippedDir2 = path.join(tempBaseDir, 'unzipped-fallback');
execSync(`powershell Expand-Archive -Path "${zipPath1}" -DestinationPath "${unzippedDir2}" -Force`, { stdio: 'inherit' });

const fallbackPkgRoot = path.join(unzippedDir2, 'ai-business-prototype-lesson-02-fallback-start-v0.1.0');

// Assert files
const pagePath = path.join(fallbackPkgRoot, 'src/pages/OrderWarningPage.vue');
const routerContent = fs.readFileSync(path.join(fallbackPkgRoot, 'src/router/index.ts'), 'utf8');
const sidebarContent = fs.readFileSync(path.join(fallbackPkgRoot, 'src/components/layout/AppSidebar.vue'), 'utf8');

if (!fs.existsSync(pagePath)) {
  throw new Error('Test 2 Failed: OrderWarningPage.vue missing in exported fallback package.');
}
if (!routerContent.includes("name: 'OrderWarning'")) {
  throw new Error('Test 2 Failed: OrderWarning route missing in exported router/index.ts.');
}
if (!sidebarContent.includes("to=\"{ name: 'OrderWarning' }\"")) {
  throw new Error('Test 2 Failed: OrderWarning menu link missing in AppSidebar.vue.');
}

// Closed-set equivalence assertion on exported ZIP
const actualFallbackFiles = collectRelativeFiles(fallbackPkgRoot, fallbackPkgRoot);
const manifestContent = fs.readFileSync(path.join(fallbackPkgRoot, 'PACKAGE_MANIFEST.txt'), 'utf8')
  .split('\n')
  .map(s => s.trim())
  .filter(Boolean)
  .sort();

if (actualFallbackFiles.join('\n') !== manifestContent.join('\n')) {
  throw new Error('Test 2 Failed: Package closed-set manifest equation failed! Disk files != PACKAGE_MANIFEST.txt');
}

// Assert forbidden paths NOT present
const prohibitedInPkg = ['course-fixtures', 'fixture-manifest.json', 'docs/LESSON_02_TEACHER_PLAN.md', 'scripts/export-student-package.ps1'];
for (const p of prohibitedInPkg) {
  if (fs.existsSync(path.join(fallbackPkgRoot, p))) {
    throw new Error(`Test 2 Failed: Prohibited path '${p}' leaked into fallback package!`);
  }
}
console.log('[PASS] Test 2 Passed: All 3 Overlays present, closed-set manifest equals disk files, no course-fixtures leaked.');

// Verify fallback package builds cleanly
console.log('\n--> Test 2.1: Fallback Package Build Verification (npm ci & verify-student-project & typecheck & build)...');
execSync('npm ci', { cwd: fallbackPkgRoot, stdio: 'inherit' });
execSync('powershell -ExecutionPolicy Bypass -File .\\scripts\\verify-student-project.ps1', { cwd: fallbackPkgRoot, stdio: 'inherit' });
execSync('npm run typecheck', { cwd: fallbackPkgRoot, stdio: 'inherit' });
execSync('npm run build', { cwd: fallbackPkgRoot, stdio: 'inherit' });

if (!fs.existsSync(path.join(fallbackPkgRoot, 'dist/index.html'))) {
  throw new Error('Test 2.1 Failed: dist/index.html missing after fallback build.');
}
console.log('[PASS] Test 2.1 Passed: Fallback Package builds 100% clean!');

// Helper for temporary git commit testing
function runTestWithTempCommit(version, mutateFn, testFn) {
  cleanArtifact(version);
  const currentHead = execSync('git rev-parse HEAD', { cwd: repoRoot }).toString().trim();
  try {
    mutateFn();
    execSync('git add -A', { cwd: repoRoot });
    execSync('git commit -m "temp test commit" --no-verify', { cwd: repoRoot });
    const tempSha = execSync('git rev-parse HEAD', { cwd: repoRoot }).toString().trim();
    testFn(tempSha);
  } finally {
    execSync(`git reset --hard ${currentHead}`, { cwd: repoRoot });
    execSync('git clean -fd', { cwd: repoRoot });
    cleanArtifact(version);
  }
}

// TEST 3 (REAL): Add Operation Target Exists Fail
console.log('\n--> Test 3: Real Add Operation Target Exists Interception Test');
let test3FailedAsExpected = false;
runTestWithTempCommit(
  'v0.1.1',
  () => {
    const manifestPath = path.join(repoRoot, 'course-fixtures/lesson-02-fallback/fixture-manifest.json');
    const tamperedManifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    // Set target of add operation to package.json which already exists in target package
    tamperedManifest.overlayFiles[0].target = "package.json";
    fs.writeFileSync(manifestPath, JSON.stringify(tamperedManifest, null, 2), 'utf8');
  },
  (tempSha) => {
    try {
      execSync(`powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-02-start" -PackageProfile "lesson-02-fallback-start" -Version "v0.1.1" -SourceRef "${tempSha}"`, { stdio: 'pipe' });
    } catch (err) {
      if (err.message.includes("already exists at 'package.json'")) {
        test3FailedAsExpected = true;
        console.log('Caught expected Add target exists error:\n' + err.message);
      }
    }
  }
);

if (!test3FailedAsExpected) {
  throw new Error('Test 3 Failed: Export script allowed fallback export when add target already existed!');
}
console.log('[PASS] Test 3 Passed: Precheck correctly aborted fallback export when add target existed.');

// TEST 4 (REAL): Replace Operation Hash Mismatch Fail
console.log('\n--> Test 4: Real Replace Operation Hash Mismatch Interception Test');
let test4FailedAsExpected = false;
runTestWithTempCommit(
  'v0.1.2',
  () => {
    const manifestPath = path.join(repoRoot, 'course-fixtures/lesson-02-fallback/fixture-manifest.json');
    const tamperedManifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    tamperedManifest.overlayFiles[1].expectedBaseSha256 = "0000000000000000000000000000000000000000000000000000000000000000";
    fs.writeFileSync(manifestPath, JSON.stringify(tamperedManifest, null, 2), 'utf8');
  },
  (tempSha) => {
    try {
      execSync(`powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-02-start" -PackageProfile "lesson-02-fallback-start" -Version "v0.1.2" -SourceRef "${tempSha}"`, { stdio: 'pipe' });
    } catch (err) {
      if (err.message.includes("normalized hash") && err.message.includes("does not match expectedBaseSha256")) {
        test4FailedAsExpected = true;
        console.log('Caught expected Hash Mismatch error:\n' + err.message);
      }
    }
  }
);

if (!test4FailedAsExpected) {
  throw new Error('Test 4 Failed: Export script allowed fallback export with mismatched base SHA256 hash!');
}
console.log('[PASS] Test 4 Passed: Precheck correctly aborted fallback export when base SHA256 hash mismatched.');

// TEST 5 (REAL): Unexpected Overlay File Interception Test
console.log('\n--> Test 5: Real Manifest Scope Enforcement Test (Extra Unmanifested Overlay File)');
let test5FailedAsExpected = false;
runTestWithTempCommit(
  'v0.1.3',
  () => {
    const extraOverlayFile = path.join(repoRoot, 'course-fixtures/lesson-02-fallback/overlay/src/pages/ExtraPage.vue');
    fs.writeFileSync(extraOverlayFile, '<template><div>Extra</div></template>', 'utf8');
  },
  (tempSha) => {
    try {
      execSync(`powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-02-start" -PackageProfile "lesson-02-fallback-start" -Version "v0.1.3" -SourceRef "${tempSha}"`, { stdio: 'pipe' });
    } catch (err) {
      if (err.message.includes("Actual overlay disk files set does not equal fixture-manifest.json")) {
        test5FailedAsExpected = true;
        console.log('Caught expected Overlay scope error:\n' + err.message);
      }
    }
  }
);

if (!test5FailedAsExpected) {
  throw new Error('Test 5 Failed: Export script allowed unmanifested extra overlay file!');
}
console.log('[PASS] Test 5 Passed: Precheck correctly aborted fallback export on unmanifested extra overlay file.');

// TEST 6 (REAL): Lesson 01 Default Export Regression Test & Closed-Set Verification
console.log('\n--> Test 6: Lesson 01 Default Export Regression & Integrity Test');
const zipPath6 = path.join(repoRoot, 'artifacts/student-packages/ai-business-prototype-lesson-01-start-v0.1.0.zip');
if (fs.existsSync(zipPath6)) fs.unlinkSync(zipPath6);
if (fs.existsSync(zipPath6 + '.sha256')) fs.unlinkSync(zipPath6 + '.sha256');

const exportCmd6 = `powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-01-start" -Version "v0.1.0" -SourceRef "HEAD"`;
execSync(exportCmd6, { cwd: repoRoot, stdio: 'inherit' });

if (!fs.existsSync(zipPath6)) {
  throw new Error('Test 6 Failed: Lesson 01 default export package missing.');
}

const unzippedDir6 = path.join(tempBaseDir, 'unzipped-lesson01');
execSync(`powershell Expand-Archive -Path "${zipPath6}" -DestinationPath "${unzippedDir6}" -Force`, { stdio: 'inherit' });
const pkg01Root = path.join(unzippedDir6, 'ai-business-prototype-lesson-01-start-v0.1.0');

// Assert closed-set manifest equation on Lesson 01 package
const actualL1Files = collectRelativeFiles(pkg01Root, pkg01Root);

const manifest01Content = fs.readFileSync(path.join(pkg01Root, 'PACKAGE_MANIFEST.txt'), 'utf8')
  .split('\n')
  .map(s => s.trim())
  .filter(Boolean)
  .sort();

if (actualL1Files.join('\n') !== manifest01Content.join('\n')) {
  throw new Error('Test 6 Failed: Lesson 01 package closed-set manifest equation failed!');
}

console.log('[PASS] Test 6 Passed: Lesson 01 default export regression test & closed-set manifest integrity verified 100%.');

// Clean up test zips
cleanArtifact('v0.1.0');
fs.unlinkSync(zipPath6);
fs.unlinkSync(zipPath6 + '.sha256');

console.log('\n========================================');
console.log('All 6 L2-C Real Integrity & Isolation Tests PASSED 100%!');
console.log('========================================\n');
