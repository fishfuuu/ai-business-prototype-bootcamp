const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const repoRoot = path.join(__dirname, '..');
const tempOutput = path.join(process.env.TEMP || 'C:\\Users\\Administrator\\AppData\\Local\\Temp', 'branch-v000-test-' + Date.now());

console.log('=== Step 18 Converged: Branch Test Package Export (v0.0.0) ===');
console.log(`Temp Output Directory: ${tempOutput}`);

try {
  // 1. Export v0.0.0 from HEAD
  console.log('1. Exporting student package v0.0.0 from HEAD...');
  execSync(`powershell -ExecutionPolicy Bypass -File .\\scripts\\export-student-package.ps1 -CourseState "lesson-01-start" -Version "v0.0.0" -SourceRef "HEAD" -OutputDirectory "${tempOutput}"`, { cwd: repoRoot, stdio: 'inherit' });

  const files = fs.readdirSync(tempOutput);
  const zipFile = files.find(f => f.endsWith('.zip'));
  if (!zipFile) {
    throw new Error('No ZIP generated in export output!');
  }

  // 2. Unzip
  console.log(`2. Unzipping ${zipFile}...`);
  const unzipDir = path.join(tempOutput, 'unzipped');
  execSync(`powershell -ExecutionPolicy Bypass -Command "Expand-Archive -Path '${path.join(tempOutput, zipFile)}' -DestinationPath '${unzipDir}'"`);

  const topItems = fs.readdirSync(unzipDir);
  const studentRoot = path.join(unzipDir, topItems[0]);

  // 3. File existence assertions
  console.log('3. Asserting files in unzipped student package...');
  if (!fs.existsSync(path.join(studentRoot, 'docs/LESSON_01_GUIDE.md'))) {
    throw new Error('LESSON_01_GUIDE.md missing in exported ZIP!');
  }
  if (fs.existsSync(path.join(studentRoot, 'docs/LESSON_01_AI_BASICS.md'))) {
    throw new Error('LESSON_01_AI_BASICS.md MUST NOT be in exported ZIP (now converged)!');
  }
  if (fs.existsSync(path.join(studentRoot, 'docs/LESSON_01_TEACHER_PLAN.md'))) {
    throw new Error('LESSON_01_TEACHER_PLAN.md MUST NOT be in exported ZIP!');
  }

  const imgs = [
    'docs/assets/lesson-01/lesson-flow.png',
    'docs/assets/lesson-01/page-layout.png',
    'docs/assets/lesson-01/component-map.png',
    'docs/assets/lesson-01/first-cohort-example.png'
  ];
  for (const img of imgs) {
    if (!fs.existsSync(path.join(studentRoot, img))) {
      throw new Error(`Image missing in exported ZIP: ${img}`);
    }
  }

  // 4. npm ci
  console.log('4. Running npm ci in unzipped package...');
  execSync('npm ci', { cwd: studentRoot, stdio: 'inherit' });

  // 5. Run student verify
  console.log('5. Running verify-student-project.ps1 in unzipped package...');
  const verifyOut = execSync('powershell -ExecutionPolicy Bypass -File .\\scripts\\verify-student-project.ps1', { cwd: studentRoot }).toString();
  if (!verifyOut.includes('Student project verification completed successfully.')) {
    throw new Error(`Student verification failed:\n${verifyOut}`);
  }
  console.log('[PASS] Student project verification passed.');

  // 6. typecheck, build
  console.log('6. Running typecheck and build in unzipped package...');
  execSync('npm run typecheck', { cwd: studentRoot, stdio: 'inherit' });
  execSync('npm run build', { cwd: studentRoot, stdio: 'inherit' });

  if (!fs.existsSync(path.join(studentRoot, 'dist/index.html'))) {
    throw new Error('dist/index.html missing after build in unzipped package!');
  }
  console.log('[PASS] typecheck and build passed in unzipped package.');

} finally {
  console.log('7. Cleaning up temporary test directory...');
  if (fs.existsSync(tempOutput)) {
    try {
      execSync(`powershell -Command "Remove-Item -Path '${tempOutput}' -Recurse -Force -ErrorAction SilentlyContinue"`);
    } catch (e) {}
  }
  console.log('[PASS] Temporary test directory cleaned up.');
}

console.log('=== Step 18 Converged Branch Test Package Passed! ===');
