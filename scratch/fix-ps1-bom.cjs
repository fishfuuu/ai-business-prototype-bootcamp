const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, '..', 'scripts', 'verify-project.ps1');
let content = fs.readFileSync(file, 'utf8');

// Ensure UTF8 BOM is present
if (!content.startsWith('\uFEFF')) {
  content = '\uFEFF' + content;
}

fs.writeFileSync(file, content, { encoding: 'utf8' });
console.log('Successfully wrote verify-project.ps1 with UTF-8 BOM');
