import fs from 'node:fs';
import path from 'node:path';
const USERNAME = process.env.GH_USERNAME || 'doanvietanh1109';
const TOKEN = process.env.GITHUB_TOKEN;
if (!TOKEN) throw new Error('Missing GITHUB_TOKEN in GitHub Actions');
const query = `query($login:String!){user(login:$login){contributionsCollection{contributionCalendar{weeks{contributionDays{date contributionCount}}}}}}`;
const response = await fetch('https://api.github.com/graphql', {
  method: 'POST',
  headers: {'Authorization': `Bearer ${TOKEN}`, 'Content-Type':'application/json', 'User-Agent':'green-github-profile'},
  body: JSON.stringify({query,variables:{login:USERNAME}})
});
if (!response.ok) throw new Error(`GitHub API ${response.status}: ${await response.text()}`);
const data = await response.json();
if (data.errors?.length) throw new Error(JSON.stringify(data.errors));
const weeks = data.data?.user?.contributionsCollection?.contributionCalendar?.weeks;
if (!weeks) throw new Error('No contribution calendar returned');
const recent = weeks.slice(-34);
const padded = Array.from({length: 34-recent.length},()=>({contributionDays: []})).concat(recent);
const grid = [];
const greens = ['#143322','#176B3B','#238D4D','#37B768','#7CF7A7'];
let maxCount=0;
for(const week of padded)for(const d of week.contributionDays)maxCount=Math.max(maxCount,d.contributionCount);
for(let i=0;i<padded.length;i++){
 for(let j=0;j<7;j++){
   const count=padded[i].contributionDays[j]?.contributionCount || 0;
   const level=count===0?0:Math.max(1,Math.min(4,Math.ceil((count/maxCount)*4)));
   grid.push(`<rect x="${53+i*30}" y="${57+j*23}" width="21" height="16" rx="3" fill="${greens[level]}">${count?`<title>${count} contributions</title>`:''}</rect>`);
 }
}
const svg=`<svg xmlns="http://www.w3.org/2000/svg" width="1120" height="280" viewBox="0 0 1120 280" role="img" aria-label="Contribution Jet for ${USERNAME}">
<rect width="1120" height="280" rx="16" fill="#08150F"/>
<rect x="1" y="1" width="1118" height="278" rx="15" fill="none" stroke="#286445" stroke-width="2"/>
<text x="50" y="33" font-size="18" fill="#62F5A0" font-weight="bold" font-family="Menlo, monospace">[05] / CONTRIBUTION FLIGHTPATH · @${USERNAME}</text>
${grid.join('\n')}
<path d="M53 231 H1068" stroke="#22583B" stroke-dasharray="7 8"/>
<g><path d="M0 -21 L8 -3 L20 3 L20 11 L5 7 L0 18 L-5 7 L-20 11 L-20 3 L-8 -3 Z" stroke="#B0FFCC" stroke-width="2" fill="#38D878"/>
<path d="M-4 14 L0 25 L4 14" fill="#FFB95F"><animate attributeName="opacity" values=".35;1;.35" dur=".2s" repeatCount="indefinite"/></path>
<animateTransform attributeName="transform" type="translate" dur="18s" repeatCount="indefinite" values="78 232;1035 232;78 232" keyTimes="0;.5;1"/></g>
<text x="52" y="261" font-family="Menlo,monospace" font-size="13" fill="#A0CDB0">LAST 34 WEEKS · REAL GITHUB CONTRIBUTIONS · UPDATED DAILY</text>
</svg>`;
fs.mkdirSync('dist',{recursive:true});
fs.writeFileSync(path.join('dist','github-jet.svg'),svg);
console.log(`Updated dist/github-jet.svg for ${USERNAME}`);
