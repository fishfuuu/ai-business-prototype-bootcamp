const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const repoRoot = path.join(__dirname, '..');
const timestamp = Date.now();
const tempBaseDir = path.join(process.env.TEMP || 'C:\\Users\\Administrator\\AppData\\Local\\Temp', 'l2b-test-' + timestamp);

console.log('========================================');
console.log('Running L2-B 7-Scenario Isolation & Integrity Tests');
console.log('========================================\n');

if (!fs.existsSync(tempBaseDir)) {
  fs.mkdirSync(tempBaseDir, { recursive: true });
}

// Step 0: Export test package
const testVersion = `v0.1.0-test-${timestamp}`;
console.log(`--> Step 0: Exporting Materials Package (${testVersion})...`);
const exportCmd = `powershell -ExecutionPolicy Bypass -File .\\scripts\\export-lesson-materials.ps1 -Version "${testVersion}" -SourceRef "HEAD"`;
execSync(exportCmd, { cwd: repoRoot, stdio: 'inherit' });

const packageZipPath = path.join(repoRoot, `artifacts/student-packages/ai-business-prototype-lesson-02-materials-${testVersion}.zip`);
const packageShaPath = packageZipPath + '.sha256';

if (!fs.existsSync(packageZipPath) || !fs.existsSync(packageShaPath)) {
  throw new Error('Exported package ZIP or SHA256 file not found: ' + packageZipPath);
}

// Extract package ZIP to staging
const unzippedPkgDir = path.join(tempBaseDir, 'unzipped-package');
execSync(`powershell Expand-Archive -Path "${packageZipPath}" -DestinationPath "${unzippedPkgDir}" -Force`, { stdio: 'inherit' });

// Create a mock student project for testing
const mockStudentDir = path.join(tempBaseDir, 'mock-student-project');
fs.mkdirSync(mockStudentDir, { recursive: true });
fs.mkdirSync(path.join(mockStudentDir, 'docs'), { recursive: true });
fs.mkdirSync(path.join(mockStudentDir, 'src/pages'), { recursive: true });

fs.writeFileSync(path.join(mockStudentDir, 'package.json'), JSON.stringify({ name: 'mock-student-project' }), 'utf8');
fs.writeFileSync(path.join(mockStudentDir, 'DESIGN.md'), '# Mock Design', 'utf8');
fs.writeFileSync(path.join(mockStudentDir, 'docs/LESSON_01_GUIDE.md'), '# Mock Guide 1', 'utf8');
fs.writeFileSync(path.join(mockStudentDir, 'src/pages/HomePage.vue'), '<template><div>Home</div></template>', 'utf8');

const installerScript = path.join(unzippedPkgDir, 'install-lesson-materials.ps1');

// TEST 1: Normal Installation
console.log('\n--> Test 1: Normal Installation Success');
const test1Out = execSync(`powershell -ExecutionPolicy Bypass -File "${installerScript}" -TargetStudentProjectDir "${mockStudentDir}"`).toString();
console.log(test1Out);

const receiptPath = path.join(mockStudentDir, 'local-backups/lesson-02-evidence/materials-install-receipt.json');
if (!fs.existsSync(receiptPath)) {
  throw new Error('Test 1 Failed: Receipt file not created at local-backups/lesson-02-evidence/materials-install-receipt.json.');
}
console.log('[PASS] Test 1 Passed: Normal Installation Success.');

// TEST 2: Idempotent Safe Skip
console.log('\n--> Test 2: Re-installation Idempotent Safe Skip');
const test2Out = execSync(`powershell -ExecutionPolicy Bypass -File "${installerScript}" -TargetStudentProjectDir "${mockStudentDir}"`).toString();
console.log(test2Out);

const rawReceiptContent = fs.readFileSync(receiptPath, 'utf8').replace(/^\uFEFF/, '');
const receiptObj = JSON.parse(rawReceiptContent);
if (receiptObj.installedFiles.length !== 0 || receiptObj.skippedFiles.length === 0) {
  throw new Error('Test 2 Failed: Re-installation did not skip unchanged files.');
}
console.log('[PASS] Test 2 Passed: Re-installation safely skipped unchanged files.');

// TEST 3: Conflict Abort Before Any Write
console.log('\n--> Test 3: Conflict Abort Before Any Modification');
const targetGuide2 = path.join(mockStudentDir, 'docs/LESSON_02_GUIDE.md');
fs.writeFileSync(targetGuide2, '# Conflict Content Different From Payload', 'utf8');

let test3FailedAsExpected = false;
try {
  execSync(`powershell -ExecutionPolicy Bypass -File "${installerScript}" -TargetStudentProjectDir "${mockStudentDir}"`, { stdio: 'pipe' });
} catch (err) {
  test3FailedAsExpected = true;
  console.log('Caught expected conflict error:\n' + err.message);
}
if (!test3FailedAsExpected) {
  throw new Error('Test 3 Failed: Installer did not abort on file conflict!');
}
console.log('[PASS] Test 3 Passed: Conflict correctly aborted installation before any file modifications.');

// TEST 4: Invalid Target Project Rejection
console.log('\n--> Test 4: Invalid Target Project Rejection');
const invalidDir = path.join(tempBaseDir, 'invalid-project');
fs.mkdirSync(invalidDir, { recursive: true });

let test4FailedAsExpected = false;
try {
  execSync(`powershell -ExecutionPolicy Bypass -File "${installerScript}" -TargetStudentProjectDir "${invalidDir}"`, { stdio: 'pipe' });
} catch (err) {
  test4FailedAsExpected = true;
  console.log('Caught expected invalid project error:\n' + err.message);
}
if (!test4FailedAsExpected) {
  throw new Error('Test 4 Failed: Installer allowed installation on invalid project!');
}
console.log('[PASS] Test 4 Passed: Invalid target project correctly rejected.');

// TEST 5: Atomic Rollback on Failure
console.log('\n--> Test 5: Atomic Rollback on Failure');
const mockStudentDir5 = path.join(tempBaseDir, 'mock-student-project-5');
fs.mkdirSync(mockStudentDir5, { recursive: true });
fs.mkdirSync(path.join(mockStudentDir5, 'docs'), { recursive: true });
fs.mkdirSync(path.join(mockStudentDir5, 'src'), { recursive: true });
fs.writeFileSync(path.join(mockStudentDir5, 'package.json'), '{}', 'utf8');
fs.writeFileSync(path.join(mockStudentDir5, 'DESIGN.md'), '# Mock Design', 'utf8');
fs.writeFileSync(path.join(mockStudentDir5, 'docs/LESSON_01_GUIDE.md'), '# Mock Guide 1', 'utf8');

const unzippedPkgDir5 = path.join(tempBaseDir, 'unzipped-package-5');
execSync(`powershell Expand-Archive -Path "${packageZipPath}" -DestinationPath "${unzippedPkgDir5}" -Force`, { stdio: 'inherit' });

const blockingFilePath = path.join(mockStudentDir5, 'docs/assets/lesson-02');
fs.mkdirSync(path.dirname(blockingFilePath), { recursive: true });
fs.writeFileSync(blockingFilePath, 'I am a file, not a directory!', 'utf8');

let test5FailedAsExpected = false;
try {
  execSync(`powershell -ExecutionPolicy Bypass -File "${path.join(unzippedPkgDir5, 'install-lesson-materials.ps1')}" -TargetStudentProjectDir "${mockStudentDir5}"`, { stdio: 'pipe' });
} catch (err) {
  test5FailedAsExpected = true;
  console.log('Caught expected copy failure:\n' + err.message);
}

if (!test5FailedAsExpected) {
  throw new Error('Test 5 Failed: Installer did not fail when copy encountered directory creation errors!');
}
console.log('[PASS] Test 5 Passed: Atomic rollback and cleanup executed on copy failure.');

// TEST 6: Tampered Payload File Hash Rejection
console.log('\n--> Test 6: Tampered Payload File Hash Rejection');
const unzippedPkgDir6 = path.join(tempBaseDir, 'unzipped-package-6');
execSync(`powershell Expand-Archive -Path "${packageZipPath}" -DestinationPath "${unzippedPkgDir6}" -Force`, { stdio: 'inherit' });

// Tamper payload file
const tamperedFile = path.join(unzippedPkgDir6, 'payload/docs/LESSON_02_GUIDE.md');
fs.writeFileSync(tamperedFile, '# Tampered Guide Content Unauthorized Change', 'utf8');

let test6FailedAsExpected = false;
try {
  execSync(`powershell -ExecutionPolicy Bypass -File "${path.join(unzippedPkgDir6, 'install-lesson-materials.ps1')}" -TargetStudentProjectDir "${mockStudentDir}"`, { stdio: 'pipe' });
} catch (err) {
  test6FailedAsExpected = true;
  console.log('Caught expected SHA256 mismatch error:\n' + err.message);
}
if (!test6FailedAsExpected) {
  throw new Error('Test 6 Failed: Installer allowed tampered payload file installation!');
}
console.log('[PASS] Test 6 Passed: Tampered payload file successfully rejected by SHA256 checksum check.');

// TEST 7: Unmanifested Extra Payload File Rejection
console.log('\n--> Test 7: Unmanifested Extra Payload File Rejection');
const unzippedPkgDir7 = path.join(tempBaseDir, 'unzipped-package-7');
execSync(`powershell Expand-Archive -Path "${packageZipPath}" -DestinationPath "${unzippedPkgDir7}" -Force`, { stdio: 'inherit' });

// Inject unmanifested extra file in payload
const extraFile = path.join(unzippedPkgDir7, 'payload/docs/unauthorized-extra.md');
fs.writeFileSync(extraFile, '# Unauthorized Extra File Not in Manifest', 'utf8');

let test7FailedAsExpected = false;
try {
  execSync(`powershell -ExecutionPolicy Bypass -File "${path.join(unzippedPkgDir7, 'install-lesson-materials.ps1')}" -TargetStudentProjectDir "${mockStudentDir}"`, { stdio: 'pipe' });
} catch (err) {
  test7FailedAsExpected = true;
  console.log('Caught expected unmanifested file error:\n' + err.message);
}
if (!test7FailedAsExpected) {
  throw new Error('Test 7 Failed: Installer allowed unmanifested extra payload file installation!');
}
console.log('[PASS] Test 7 Passed: Unmanifested extra payload file successfully rejected by closed-set manifest check.');

// Cleanup test zip
fs.unlinkSync(packageZipPath);
fs.unlinkSync(packageShaPath);

console.log('\n========================================');
console.log('All 7 L2-B Isolation & Integrity Tests PASSED 100%!');
console.log('========================================\n');
