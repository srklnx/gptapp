const screenNames = {
  home: ["Home", "الرئيسية"], flock: ["Flock", "القطيع"], groups: ["Groups", "المجموعات"],
  scan: ["Scan tag", "مسح الشارة"], overview: ["Sheep profile", "ملف الخروف"],
  health: ["Health", "الصحة"], breeding: ["Breeding", "التناسل"], weight: ["Weight & BCS", "الوزن والحالة"],
  timeline: ["Timeline", "السجل"], quick: ["Quick Log", "تسجيل سريع"], treatment: ["Treatment entry", "إضافة علاج"],
  bulk: ["Bulk action", "إجراء جماعي"], tasks: ["Tasks", "المهام"], sync: ["Sync center", "مركز المزامنة"],
  heat: ["Heat stress", "الإجهاد الحراري"], eid: ["Eid mode", "وضع الأضاحي"], more: ["More & settings", "المزيد والإعدادات"],
  design: ["Design system", "نظام التصميم"], empty: ["Empty state", "حالة فارغة"], error: ["Error state", "حالة الخطأ"]
};
const t = {
  "Al Noor Farm":"مزرعة النور", "North Flock":"القطيع الشمالي", "Offline · Changes saved locally":"دون اتصال · حُفظت التغييرات محلياً",
  "12 changes waiting to sync":"١٢ تغييراً بانتظار المزامنة", "HEAT RISK · HIGH":"خطر الحرارة · مرتفع",
  "NEEDS ATTENTION":"يحتاج إلى متابعة", "Urgent":"عاجل", "Due today":"مستحق اليوم", "Due this week":"هذا الأسبوع",
  "4 sheep · vaccination due":"٤ أغنام · موعد التحصين", "3 sheep · withdrawal active":"٣ أغنام · فترة السحب", "2 sheep · low body condition":"خروفان · حالة جسم منخفضة",
  "See all":"عرض الكل", "Today's tasks":"مهام اليوم", "Start tasks":"ابدأ المهام", "Vaccinate pregnant ewes":"تحصين النعاج الحوامل",
  "Check water · North Pasture":"فحص الماء · المرعى الشمالي", "Weigh lambs · Group B":"وزن الحملان · المجموعة ب",
  "BCS check · 12 ewes":"تقييم الحالة · ١٢ نعجة", "Flock snapshot":"ملخص القطيع", "Total sheep":"إجمالي الأغنام",
  "Ewes":"نعاج", "Rams":"كباش", "Lambs":"حملان", "Pregnant":"حوامل", "Sick / isolation":"مريضة / عزل",
  "Search tag, group, breed…":"ابحث عن الشارة أو المجموعة أو السلالة…", "Scan tag":"مسح الشارة", "Add sheep":"إضافة خروف",
  "All":"الكل", "Ewe":"نعجة", "Ram":"كبش", "Lamb":"حمل", "Withdrawal":"فترة السحب", "Due today":"مستحق اليوم",
  "Due for vaccination":"موعد التحصين", "Due for deworming":"موعد مضاد الديدان", "Withdrawal active":"فترة السحب فعالة",
  "Low BCS":"حالة جسم منخفضة", "Eid candidates":"مرشحو الأضاحي", "Needs attention":"يحتاج إلى متابعة", "Vaccination · 3 days":"التحصين · بعد ٣ أيام",
  "Awassi · Ewe · BCS 2.5":"عواسي · نعجة · حالة ٢٫٥", "Attention":"يحتاج متابعة", "Healthy":"سليم",
  "What do you want to record?":"ما الذي تريد تسجيله؟", "HEALTH":"الصحة", "CONDITION":"الحالة", "BREEDING":"التناسل", "OTHER":"أخرى",
  "Treatment":"علاج", "Vaccination":"تحصين", "Deworming":"مضاد الديدان", "Dipping / parasite":"تغطيس / طفيليات",
  "Hoof trim":"تقليم الحوافر", "Shearing":"جزّ الصوف", "Weight":"الوزن", "BCS":"حالة الجسم", "Heat check":"فحص الحرارة",
  "Feed / water":"علف / ماء", "Mating":"التلقيح", "Pregnancy":"الحمل", "Lambing":"الولادة", "Photo":"صورة",
  "Voice note":"ملاحظة صوتية", "Note":"ملاحظة", "Treatment saved":"تم حفظ العلاج", "Follow-up created":"تم إنشاء متابعة",
  "Save treatment":"حفظ العلاج", "Al Noor Farm · North Flock":"مزرعة النور · القطيع الشمالي", "Today's tasks · 12":"مهام اليوم · ١٢",
  "Due today":"مستحق اليوم", "Priority: High":"الأولوية: عالية", "Start":"ابدأ", "Today":"اليوم", "Upcoming":"القادمة", "Completed":"المكتملة",
  "Expected lambing":"موعد الولادة المتوقع", "Mating date":"تاريخ التلقيح", "Ram":"الكبش", "Pregnancy status":"حالة الحمل",
  "Gregorian":"ميلادي", "Hijri":"هجري", "Eid in 42 days":"العيد بعد ٤٢ يوماً", "CLEAR FOR SALE":"مصرّح للبيع",
  "NOT CLEAR FOR SALE":"غير مصرّح للبيع", "12 changes pending":"١٢ تغييراً بانتظار المزامنة", "All changes synced":"تمت مزامنة جميع التغييرات",
  "Syncing 12 changes…":"جارٍ مزامنة ١٢ تغييراً…", "Scan Sheep Tag":"امسح شارة الخروف", "Open profile":"فتح الملف",
  "Quick log":"تسجيل سريع", "Scan next":"مسح التالي", "Batch scan":"مسح مجموعة", "Group":"المجموعة", "Pasture North":"المرعى الشمالي",
  "Breeding status":"حالة التناسل", "Health routines":"الرعاية الدورية", "Active treatments":"العلاجات الفعالة",
  "Last: 12 Aug 2026":"آخر مرة: ١٢ أغسطس ٢٠٢٦", "Next: 12 Feb 2027":"التالي: ١٢ فبراير ٢٠٢٧",
  "5 days remaining":"متبقي ٥ أيام", "Clearance · 3 Oct 2026":"انتهاء السحب · ٣ أكتوبر ٢٠٢٦",
  "NOT CLEAR FOR SALE":"غير مصرّح للبيع", "Move to shade":"انقلها إلى الظل", "Check water":"افحص الماء",
  "Avoid handling":"تجنّب التعامل معها", "Recheck in 30 min":"أعد الفحص بعد ٣٠ دقيقة", "Record heat check":"تسجيل فحص الحرارة",
  "Factors":"العوامل", "Water availability":"توفر الماء", "Handling risk":"مخاطر التعامل", "Temperature":"درجة الحرارة",
  "Settings":"الإعدادات", "Languages":"اللغات", "Calendar":"التقويم", "Regional protocols":"البروتوكولات الإقليمية",
  "Farm settings":"إعدادات المزرعة", "Medication":"الأدوية", "Reports":"التقارير", "Users":"المستخدمون",
  "Sync center":"مركز المزامنة", "Field mode":"الوضع الميداني", "Design system":"نظام التصميم",
  "No sheep here yet":"لا توجد أغنام هنا بعد", "Add your first sheep":"أضف أول خروف إلى القطيع",
  "Something didn’t sync":"تعذرت المزامنة", "Your records are safe on this device.":"سجلاتك محفوظة بأمان على هذا الجهاز.",
  "Try again":"أعد المحاولة", "General":"عام", "Groups":"المجموعات", "More":"المزيد",
  "Home":"الرئيسية", "Flock":"القطيع", "Tasks":"المهام", "Breeding":"التناسل", "Quick Log":"تسجيل سريع",
  "Scan":"مسح", "Alerts":"التنبيهات", "Save":"حفظ", "Save locally":"حفظ محلياً", "Close":"إغلاق", "Edit":"تعديل",
  "Overview":"نظرة عامة", "Health":"الصحة", "Weight & BCS":"الوزن والحالة", "Timeline":"السجل", "Identity":"الهوية",
  "Current status":"الحالة الحالية", "Recent activity":"النشاط الأخير", "Tag":"الشارة", "Breed":"السلالة", "Sex":"الجنس",
  "Birth date":"تاريخ الميلاد", "Location":"الموقع", "Current weight":"الوزن الحالي", "Last 6 months":"آخر ٦ أشهر",
  "Weight recorded":"تم تسجيل الوزن", "Treatment · Albendazole":"علاج · ألبيندازول", "BCS recorded · 2.5":"تقييم الحالة · ٢٫٥",
  "Vaccination · Clostridial":"تحصين · كلوستريدي", "by Ahmed":"بواسطة أحمد", "by Sara":"بواسطة سارة", "Today · 30 Sep":"اليوم · ٣٠ سبتمبر",
  "28 Sep 2026":"٢٨ سبتمبر ٢٠٢٦", "20 Sep 2026":"٢٠ سبتمبر ٢٠٢٦", "12 Aug 2026":"١٢ أغسطس ٢٠٢٦",
  "No withdrawal":"لا توجد فترة سحب", "62.4 kg":"٦٢٫٤ كغ", "62 kg":"٦٢ كغ", "North pasture":"المرعى الشمالي",
  "Needs attention":"يحتاج إلى متابعة", "Group B":"المجموعة ب", "47 sheep selected":"٤٧ خروفاً محدداً",
  "Vaccinate 47 sheep":"تحصين ٤٧ خروفاً", "47 records saved":"تم حفظ ٤٧ سجلاً", "Vaccination due in 3 days":"موعد التحصين بعد ٣ أيام",
  "Shearing":"جزّ الصوف", "Dipping":"التغطيس", "Supplements":"المكملات", "Last · 12 Aug 2026":"آخر مرة · ١٢ أغسطس ٢٠٢٦",
  "Next · 12 Feb 2027":"التالي · ١٢ فبراير ٢٠٢٧", "No pregnancy recorded":"لم يُسجل حمل", "Mating · 08 Sep 2026":"التلقيح · ٨ سبتمبر ٢٠٢٦",
  "Karakul #R12":"كركول #R12", "Expected · 02 Feb 2027":"المتوقع · ٢ فبراير ٢٠٢٧", "Open":"فتح", "Add note":"إضافة ملاحظة",
  "Record weight":"تسجيل الوزن", "Move group":"نقل المجموعة", "Eid Candidates":"مرشحو الأضاحي", "Due for Vaccination":"موعد التحصين",
  "Due for Deworming":"موعد مضاد الديدان", "Low BCS":"حالة جسم منخفضة", "Withdrawal Active":"فترة السحب فعالة",
  "Needs Attention":"يحتاج إلى متابعة", "Lambs":"حملان", "Vaccinate Pregnant Ewes":"تحصين النعاج الحوامل"
};

const state = { screen:"home", profileTab:"overview", locale:"en", mode:"light", filter:"All", taskTab:"Today", calendar:"Gregorian", modal:false, confirmation:false, scanFound:false, search:"" };
const phone = document.querySelector(".phone-screen");
const view = document.getElementById("app-view");
const nav = document.getElementById("bottom-nav");
const linkList = document.getElementById("screen-links");
const localeToggle = document.getElementById("locale-toggle");
const modeSelect = document.getElementById("mode-select");

function text(value) { return state.locale === "ar" ? (t[value] || value) : value; }
function arabicNumber(value) { return state.locale === "ar" ? String(value).replace(/[0-9]/g, n => "٠١٢٣٤٥٦٧٨٩"[n]) : value; }
function title(key) { return screenNames[key][state.locale === "ar" ? 1 : 0]; }
function btn(label, action, cls="button") { return `<button class="${cls}" data-action="${action}">${text(label)}</button>`; }
function section(titleText, right="") { return `<div class="section-head"><h2>${text(titleText)}</h2>${right}</div>`; }
function header() { return `<div class="app-header"><div><div class="farm-name">${text("Al Noor Farm")}</div><div class="header-meta">${text("North Flock")} · ${text("486 sheep")}</div></div><button class="avatar" data-screen="more" aria-label="${text("Profile")}">AN</button></div>`; }
function shell(content) { return `<div class="app-pad">${content}</div>`; }
function status(textValue, kind="") { return `<span class="status-pill ${kind}">${text(textValue)}</span>`; }
function sheepCard(tag, breed, sex, bcs, stat, next, kind="") {
  return `<article class="sheep-card" data-screen="overview"><div class="sheep-avatar">🐑</div><div class="sheep-info"><strong>${text(tag)}</strong><small>${text(breed)} · ${text(sex)} · ${text("BCS")} ${bcs}</small></div>${status(stat,kind)}<div class="sheep-next">${text("Next")}: <b>${text(next)}</b></div></article>`;
}
function renderHome() {
  return shell(`${header()}<div class="weather-banner"><div><div class="weather-number">43° <span class="weather-unit">C</span></div><div class="offline-line"><span>${text("Offline · Changes saved locally")}</span></div></div><div class="weather-risk"><strong>${text("HEAT RISK · HIGH")}</strong>28% humidity · 14:20<br>${text("12 changes waiting to sync")}</div></div>
    ${section("NEEDS ATTENTION",`<button class="text-action" data-screen="tasks">${text("See all")}</button>`)}
    <div class="attention-strip"><div class="attention-count urgent"><strong>3</strong><span>${text("Urgent")}</span></div><div class="attention-count due"><strong>8</strong><span>${text("Due today")}</span></div><div class="attention-count week"><strong>14</strong><span>${text("Due this week")}</span></div></div>
    <div class="alert-row" data-screen="tasks"><i class="alert-marker red"></i><div class="alert-copy">${text("4 sheep · vaccination due")}<small>${text("Pregnant Ewes")} · ${text("Priority: High")}</small></div><span class="chevron">›</span></div>
    <div class="alert-row" data-screen="health"><i class="alert-marker"></i><div class="alert-copy">${text("3 sheep · withdrawal active")}<small>#184, #209, #311</small></div><span class="chevron">›</span></div>
    <div class="alert-row" data-screen="flock"><i class="alert-marker olive"></i><div class="alert-copy">${text("2 sheep · low body condition")}<small>${text("Needs attention")}</small></div><span class="chevron">›</span></div>
    ${section("Today's tasks",`<button class="text-action" data-screen="tasks">${text("Start tasks")}</button>`)}
    <div class="task-row" data-screen="tasks"><span class="task-check"></span><div class="task-name">${text("Vaccinate pregnant ewes")}<small>${text("Due today")} · ${text("Priority: High")}</small></div><span class="task-qty">47</span></div>
    <div class="task-row" data-screen="tasks"><span class="task-check"></span><div class="task-name">${text("Check water · North Pasture")}<small>${text("Due today")}</small></div><span class="chevron">›</span></div>
    ${section("Flock snapshot",`<button class="text-action" data-screen="flock">${text("See all")}</button>`)}
    <div class="metric-grid"><div class="metric-tile"><strong>486</strong><span>${text("Total sheep")}</span></div><div class="metric-tile"><strong>312</strong><span>${text("Ewes")}</span></div><div class="metric-tile"><strong>18</strong><span>${text("Rams")}</span></div><div class="metric-tile"><strong>156</strong><span>${text("Lambs")}</span></div></div>
    <div class="section-head"><h2>${text("Heat Risk")} · ${text("HIGH")}</h2><button class="text-action" data-screen="heat">${text("See all")}</button></div>
    <div class="heat-card"><div class="heat-top"><strong>${text("HIGH")} · 14:20</strong><span class="heat-temp">43°</span></div><div class="heat-factors"><div class="heat-factor">${text("Temperature")}<b>↑ 43°C</b></div><div class="heat-factor">${text("Water availability")}<b>⚠ ${text("Check water")}</b></div><div class="heat-factor">${text("Handling risk")}<b>↑ ${text("High")}</b></div></div><div class="recommend"><b>${text("Recommended")}:</b> ${text("Move to shade")} · ${text("Check water")} · ${text("Avoid handling")}</div><button class="button small" style="margin-top:10px" data-screen="heat">${text("Start Heat Check")}</button></div>`);
}
function renderFlock() {
  const sheep = [
    ["#184","Awassi","Ewe","2.5","Attention","Vaccination · 3 days",""],
    ["#209","Awassi","Ewe","3.0","Withdrawal","5 days remaining","withdrawal"],
    ["#311","Najdi","Ram","3.0","Healthy","Weight check · 12 Oct","good"],
    ["#472","Awassi","Lamb","2.0","Attention","BCS check due",""]
  ];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Flock")}</h1><div class="heading-count">${text("486 sheep")}</div></div><div class="header-actions"><button class="icon-button" data-screen="scan" aria-label="${text("Scan tag")}">⌗</button><button class="button small" data-action="add-sheep">+ ${text("Add sheep")}</button></div></div>
    <div class="search-box"><span>⌕</span><input id="flock-search" value="${state.search}" placeholder="${text("Search tag, group, breed…")}"></div>
    <div class="filter-row">${["All","Ewes","Rams","Lambs","Pregnant","Sick","Withdrawal","Due today"].map(f=>`<button class="filter-chip ${state.filter===f?"selected":""}" data-filter="${f}">${text(f)}</button>`).join("")}</div>
    ${section("Saved views")}
    <div class="saved-views">${[["◷","Due for Vaccination"],["◌","Due for Deworming"],["!","Withdrawal Active"],["↘","Low BCS"],["♡","Pregnant"],["✧","Eid Candidates"],["•","Needs Attention"]].map(([i,n])=>`<button class="saved-view" data-filter="${n}"><span class="saved-icon">${i}</span>${text(n)}</button>`).join("")}</div>
    ${section("All sheep",`<button class="text-action">${text("Sort")}⌄</button>`)}
    ${sheep.map(s=>sheepCard(...s)).join("")}`);
}
function renderGroups() {
  const groups=[["♡","Pregnant Ewes","Next action · Vaccination","47"],["◌","Dry Ewes","All routines up to date","86"],["♞","Rams","North paddock · 18 sheep","18"],["✧","Lambs · Group B","Weight check due today","32"],["＋","Sick / Isolation","2 sheep · review today","2"],["⌂","Pasture North","Water check due","124"],["◇","Eid Candidates","Health-cleared candidates","26"]];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Groups")}</h1><div class="heading-count">${text("Manage flock together")}</div></div><button class="icon-button" data-action="new-group">＋</button></div>
    <div class="search-box">⌕ <input placeholder="${text("Search groups…")}"></div>${section("Smart groups")}
    ${groups.map(g=>`<article class="group-card" data-screen="bulk"><div class="group-icon">${g[0]}</div><div class="group-info"><strong>${text(g[1])}</strong><small>${text(g[2])}</small></div><div class="group-count">${g[3]}<small>${text("sheep")}</small></div><span class="chevron">›</span></article>`).join("")}`);
}
function renderScan() {
  if(state.scanFound) return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Scan Sheep Tag")}</h1><div class="heading-count">${text("Tag detected")}</div></div><button class="icon-button" data-screen="flock">×</button></div><div class="scanner-area"><div class="scan-line"></div><div class="scanner-center"><span>✓</span>${text("Tag detected")}</div></div><div class="scan-result"><div class="sheep-avatar">🐑</div><div class="scan-result-info"><strong>#184 · ${text("Awassi Ewe")}</strong><small>${text("BCS")} 2.5 · ${text("Attention")}</small></div>${status("Attention")}</div><button class="button full" data-screen="overview">${text("Open profile")}</button><button class="button secondary full" style="margin-top:7px" data-screen="quick">${text("Quick log")}</button><button class="button ghost full" style="margin-top:4px" data-action="scan-next">${text("Scan next")} →</button>`);
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Scan Sheep Tag")}</h1><div class="heading-count">${text("Point camera at an ear tag")}</div></div><button class="icon-button" data-screen="flock">×</button></div><div class="scanner-area" data-action="simulate-scan"><div class="scan-line"></div><div class="scanner-center"><span>⌗</span>${text("Align tag within frame")}<br><small>${text("Tap to simulate scan")}</small></div></div><div class="content-card" style="margin-top:12px"><strong style="font-size:10px">${text("Rapid scanning")}</strong><p style="margin:5px 0 0;color:var(--muted);font-size:8px">${text("Scan one animal after another, or record a whole group at once.")}</p><button class="button secondary small" style="margin-top:10px" data-action="batch-scan">${text("Batch scan")}</button></div>`);
}
function profileHeader() {
  return `<div class="profile-hero"><div class="profile-cover">🐑</div><div class="profile-meta"><div><h2>#184</h2><p>${text("Awassi")} · ${text("Ewe")} · ${text("Pasture North")}</p></div><div class="profile-bcs">2.5<small>${text("BCS")}</small></div>${status("Attention")}</div><div class="profile-actions"><button class="button" data-screen="quick">${text("Quick Log")}</button><button class="button secondary" data-action="edit">${text("Edit")}</button></div></div>
    <div class="tabs">${["overview","health","breeding","weight","timeline"].map(tab=>`<button class="tab ${state.profileTab===tab?"active":""}" data-profile-tab="${tab}">${text(screenNames[tab][0])}</button>`).join("")}</div>`;
}
function profileOverview() {
  return `${section("Identity")}<div class="content-card"><div class="detail-list">${[["Tag","#184"],["Breed","Awassi"],["Sex","Ewe"],["Birth date","14 Mar 2023"],["Group","Pregnant Ewes"],["Location","North pasture"]].map(x=>`<div class="detail-item"><span>${text(x[0])}</span><strong>${text(x[1])}</strong></div>`).join("")}</div></div>
  ${section("Current status")}<div class="content-card"><div class="detail-list"><div class="detail-item"><span>${text("Weight")}</span><strong>${text("62.4 kg")}</strong></div><div class="detail-item"><span>${text("BCS")}</span><strong>2.5 / 5</strong></div><div class="detail-item"><span>${text("Pregnancy")}</span><strong>${text("Expected lambing")} · 2 Feb</strong></div><div class="detail-item"><span>${text("Withdrawal")}</span><strong>${text("No withdrawal")}</strong></div></div></div>
  ${section("Recent activity",`<button class="text-action" data-profile-tab="timeline">${text("See all")}</button>`)}<div class="timeline"><div class="timeline-event"><time>${text("Today · 30 Sep")}</time><strong>${text("BCS recorded · 2.5")}</strong><p>${text("by Ahmed")}</p></div><div class="timeline-event"><time>${text("28 Sep 2026")}</time><strong>${text("Treatment · Albendazole")}</strong><p>10 ml · ${text("by Sara")}</p></div><div class="timeline-event"><time>${text("20 Sep 2026")}</time><strong>${text("Weight recorded")} · 62.4 kg</strong><p>${text("by Ahmed")}</p></div></div>`;
}
function profileHealth() {
  const routines=[["Vaccination","12 Aug 2026","12 Feb 2027"],["Deworming","04 Jul 2026","04 Jan 2027"],["Dipping","18 Jun 2026","18 Dec 2026"],["Hoof trimming","10 May 2026","10 Nov 2026"],["Shearing","02 Apr 2026","02 Apr 2027"],["Supplements","15 Sep 2026","15 Oct 2026"]];
  return `${section("Health routines")}<div class="content-card">${routines.map(r=>`<div class="routine-row"><div><strong>${text(r[0])}</strong><small>${text("Last")}: ${text(r[1])}</small></div><div class="routine-date">${text("Next")}<small>${text(r[2])}</small></div></div>`).join("")}</div>
  ${section("Active treatments")}<div class="withdrawal-box"><div class="eyebrow">${text("WITHDRAWAL ACTIVE")}</div><h3>Albendazole</h3><p style="font-size:8px;color:var(--muted);margin:0 0 7px">${text("Administered")}: 28 Sep 2026 · 10 ml oral</p><div class="withdrawal-count"><strong>5 <span>${text("days remaining")}</span></strong><span>${text("Clearance · 3 Oct 2026")}</span></div><div class="sale-warning">⊘ &nbsp;${text("NOT CLEAR FOR SALE")}</div></div>`;
}
function profileBreeding() {
  return `${section("Breeding status")}<div class="content-card"><div class="detail-list"><div class="detail-item"><span>${text("Pregnancy status")}</span><strong>${text("Confirmed")}</strong></div><div class="detail-item"><span>${text("Mating date")}</span><strong>08 Sep 2026</strong></div><div class="detail-item"><span>${text("Ram")}</span><strong>${text("Karakul #R12")}</strong></div><div class="detail-item"><span>${text("Expected lambing")}</span><strong>02 Feb 2027</strong></div></div></div>
    ${section("Lambing timeline")}<div class="content-card"><div class="timeline"><div class="timeline-event"><time>02 Feb 2027 · ${text("Expected")}</time><strong>${text("Expected lambing")}</strong><p>${text("Pregnancy")} · Day 22 of 147</p></div><div class="timeline-event"><time>08 Sep 2026</time><strong>${text("Mating")} · ${text("Karakul #R12")}</strong><p>${text("Recorded")} ${text("by Ahmed")}</p></div><div class="timeline-event"><time>12 Feb 2026</time><strong>${text("Lambing history")}</strong><p>Twins · healthy</p></div></div></div>`;
}
function profileWeight() {
  return `${section("Current weight")}<div class="content-card"><div style="display:flex;justify-content:space-between;align-items:end"><div><strong style="font-size:27px;color:var(--forest)">${text("62.4 kg")}</strong><span style="font-size:8px;color:var(--muted);margin-left:5px">+1.2 kg</span></div>${status("Healthy","good")}</div><div class="chart"><svg viewBox="0 0 300 90" role="img" aria-label="Weight trend chart"><path d="M3 69 C35 61 41 65 67 55 S103 60 129 43 S162 50 187 32 S225 37 248 23 S280 28 298 12" fill="none" stroke="var(--forest)" stroke-width="3" stroke-linecap="round"/><path d="M3 69 C35 61 41 65 67 55 S103 60 129 43 S162 50 187 32 S225 37 248 23 S280 28 298 12 L298 90 L3 90Z" fill="var(--green-soft)" opacity=".7"/><circle cx="298" cy="12" r="4" fill="var(--forest)"/></svg><div class="chart-labels"><span>Apr</span><span>May</span><span>Jun</span><span>Jul</span><span>Aug</span><span>Sep</span></div></div></div>
    ${section("Body condition score")}<div class="content-card"><div style="display:flex;justify-content:space-between;align-items:center"><strong style="font-size:11px">${text("BCS")} · 2.5 / 5</strong>${status("On target","good")}</div><div class="bcs-select">${["2.0","2.5","3.0"].map(n=>`<button class="${n==="2.5"?"selected":""}" data-bcs="${n}">${n}</button>`).join("")}</div><button class="button full" data-action="save-bcs">${text("Save")} · 2.5</button></div>`;
}
function profileTimeline() {
  return `${section("Recent activity",`<button class="text-action">${text("Filter")}⌄</button>`)}<div class="timeline"><div class="timeline-event"><time>${text("Today · 30 Sep")} · 09:18</time><strong>${text("BCS recorded · 2.5")}</strong><p>${text("by Ahmed")} · ${text("Condition")}</p></div><div class="timeline-event"><time>28 Sep 2026 · 16:42</time><strong>${text("Treatment · Albendazole")}</strong><p>10 ml oral · ${text("by Sara")} · ${text("5 days remaining")}</p></div><div class="timeline-event"><time>20 Sep 2026 · 07:55</time><strong>${text("Weight recorded")} · 62.4 kg</strong><p>${text("by Ahmed")} · ${text("Weight")}</p></div><div class="timeline-event"><time>08 Sep 2026 · 08:15</time><strong>${text("Mating")} · ${text("Karakul #R12")}</strong><p>${text("by Ahmed")} · ${text("Breeding")}</p></div><div class="timeline-event"><time>12 Aug 2026 · 10:03</time><strong>${text("Vaccination · Clostridial")}</strong><p>2 ml · ${text("by Sara")}</p></div></div><button class="button secondary full" data-screen="quick">${text("Quick Log")}</button>`;
}
function renderProfile() {
  const page={overview:profileOverview,health:profileHealth,breeding:profileBreeding,weight:profileWeight,timeline:profileTimeline}[state.profileTab]();
  return shell(`<div class="page-heading"><div><div class="heading-count">← ${text("Flock")}</div></div><button class="icon-button" data-action="share">···</button></div>${profileHeader()}${page}`);
}
function renderQuick() {
  const sections=[
    ["HEALTH",[["💊","Treatment"],["💉","Vaccination"],["🪱","Deworming"],["🧴","Dipping / parasite"],["🦶","Hoof trim"],["✂","Shearing"]]],
    ["CONDITION",[["⚖","Weight"],["◉","BCS"],["🌡","Heat check"],["💧","Feed / water"]]],
    ["BREEDING",[["♡","Mating"],["🐑","Pregnancy"],["🍼","Lambing"]]],
    ["OTHER",[["▧","Photo"],["♬","Voice note"],["▤","Note"]]]
  ];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Quick Log")}</h1><div class="heading-count">#184 · ${text("Awassi")} ${text("Ewe")}</div></div><button class="icon-button" data-screen="overview">×</button></div><div class="notice"><span>●</span><span>${text("Offline · Changes saved locally")}<br><strong>${text("Last used")}: ${text("BCS")}</strong></span></div>${sections.map(([heading,items])=>`<div class="sheet-section"><h3>${text(heading)}</h3><div class="sheet-grid">${items.map(([glyph,name])=>`<button class="sheet-action" data-quick-action="${name}"><span>${glyph}</span>${text(name)}</button>`).join("")}</div></div>`).join("")}`);
}
function renderTreatment() {
  if(state.confirmation) return shell(`<div class="confirmation"><div class="confirm-mark">✓</div><h2>${text("Treatment saved")}</h2><p>${text("Follow-up created")} · 3 Oct 2026<br>#184 · Albendazole · ${text("saved locally")}</p><button class="button" data-action="close-confirm">${text("Done")}</button></div>`);
  return shell(`<div class="page-heading"><div><div class="heading-count">← ${text("Quick Log")}</div><h1 class="section-title" style="margin-top:5px">${text("Treatment")}</h1></div><button class="icon-button" data-screen="quick">×</button></div>
    <div class="scan-result"><div class="sheep-avatar">🐑</div><div class="scan-result-info"><strong>#184 · ${text("Awassi Ewe")}</strong><small>${text("Pregnant")} · ${text("BCS")} 2.5</small></div><button class="text-action" data-screen="scan">${text("Change")}</button></div>
    <div class="form-field"><label>${text("Medication")}</label><select><option>Albendazole · 10%</option><option>Oxytetracycline</option><option>Ivermectin</option></select></div><div class="form-two"><div class="form-field"><label>${text("Dose")}</label><input value="10 ml"></div><div class="form-field"><label>${text("Route")}</label><select><option>${text("Oral")}</option><option>Injection</option></select></div></div>
    <div class="form-two"><div class="form-field"><label>${text("Date")}</label><input value="30 Sep 2026"></div><div class="form-field"><label>${text("Time")}</label><input value="09:42"></div></div>
    <div class="withdrawal-box" style="margin:8px 0"><div class="eyebrow">${text("WITHDRAWAL · AUTO-CALCULATED")}</div><div class="withdrawal-count"><strong>5 ${text("days")}</strong><span>${text("Clearance · 5 Oct 2026")}</span></div><div class="sale-warning">⊘ &nbsp;${text("NOT CLEAR FOR SALE")}</div></div>
    <button class="button full" style="margin-top:12px" data-action="save-treatment">${text("Save treatment")}</button><p style="text-align:center;color:var(--muted);font-size:8px">✓ ${text("Follow-up reminder will be created")}</p>`);
}
function renderBulk() {
  if(state.confirmation) return shell(`<div class="confirmation"><div class="confirm-mark">✓</div><h2>${text("47 records saved")}</h2><p>${text("Vaccination")} · ${text("Pregnant Ewes")}<br>${text("Timeline updated for all sheep")} · ${text("saved locally")}</p><button class="button" data-action="close-confirm">${text("Done")}</button></div>`);
  return shell(`<div class="page-heading"><div><div class="heading-count">← ${text("Groups")}</div><h1 class="section-title" style="margin-top:5px">${text("Bulk action")}</h1></div><button class="icon-button" data-screen="groups">×</button></div>
    <div class="group-card"><div class="group-icon">♡</div><div class="group-info"><strong>${text("Pregnant Ewes")}</strong><small>${text("47 sheep selected")} · ${text("North Flock")}</small></div><span class="chevron">✓</span></div>
    <div class="form-field"><label>${text("Action")}</label><select><option>${text("Vaccination")}</option><option>${text("Deworming")}</option><option>${text("Weight")}</option></select></div>
    <div class="form-field"><label>${text("Vaccine")}</label><select><option>Clostridial 5-in-1</option><option>Enterotoxemia</option><option>Custom protocol</option></select></div>
    <div class="form-two"><div class="form-field"><label>${text("Date")}</label><input value="30 Sep 2026"></div><div class="form-field"><label>${text("Batch / lot")}</label><input value="VX-260930"></div></div>
    <div class="notice"><span>●</span><span>${text("47 sheep will receive an individual timeline record. You can review exceptions before saving.")}</span></div>
    <button class="button full" style="margin-top:14px" data-action="save-bulk">${text("Vaccinate 47 sheep")}</button><button class="button ghost full" style="margin-top:4px" data-action="exceptions">${text("Review sheep")}</button>`);
}
function renderTasks() {
  const tasks=state.taskTab==="Completed"?[["Water troughs · North Pasture","Completed 08:25 · Ahmed","Done"],["BCS check · 12 ewes","Completed 07:40 · Sara","Done"]]:state.taskTab==="Upcoming"?[["Deworm Lambs · Group B","Due tomorrow · 32 sheep","Medium"],["Hoof trim · Dry Ewes","Due 04 Oct · 18 sheep","Normal"]]:[["Vaccinate Pregnant Ewes","47 sheep · Pregnant Ewes","High"],["Check Water · North Pasture","Pasture North · 3 troughs","High"],["Weigh Lambs · Group B","32 lambs · Group B","Medium"],["BCS Check · 12 ewes","12 sheep · North Flock","Normal"]];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Tasks")}</h1><div class="heading-count">${text("12 tasks")} · ${text("Today")}</div></div><button class="icon-button" data-action="filter-tasks">⌄</button></div><div class="tabs">${["Today","Upcoming","Completed"].map(x=>`<button class="tab ${state.taskTab===x?"active":""}" data-task-tab="${x}">${text(x)}</button>`).join("")}</div>
    ${tasks.map((a,i)=>`<article class="task-card"><div class="task-card-top"><h3>${text(a[0])}</h3>${status(a[2],a[2]==="High"?"urgent":a[2]==="Done"?"good":"")}</div><p>${text(a[1])}</p><div class="task-card-footer"><span class="${a[2]==="High"?"priority":""}">${text(a[2]==="High"?"Priority: High":a[2])}</span>${a[2]==="Done"?`<span>✓ ${text("Completed")}</span>`:`<button class="button small" data-action="${i===0?"bulk-task":"start-task"}">${text("Start")}</button>`}</div></article>`).join("")}
    <button class="button secondary full" data-action="add-task">＋ ${text("Add task")}</button>`);
}
function renderSync() {
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Sync center")}</h1><div class="heading-count">${text("Your data stays on this device first")}</div></div><button class="icon-button" data-action="sync-now">↻</button></div>
    <div class="sync-summary"><div class="sync-glyph">↯</div><strong>${text("Offline · Changes saved locally")}</strong><span>${text("12 changes pending")} · ${text("Last synced")} 28 Sep 2026</span></div>
    ${section("Pending",`<span class="status-pill">${arabicNumber("12")} ${text("items")}</span>`)}
    ${[["✓","BCS · #184","Today · 09:18"],["💊","Treatment · #184","Today · 09:12"],["⚖","Weight · Group B (32)","Today · 08:44"],["💉","Vaccination · 47 ewes","Today · 08:20"],["▤","Note · North Pasture","Yesterday · 17:32"]].map(x=>`<div class="sync-item"><span class="sync-icon">${x[0]}</span><div><strong>${text(x[1])}</strong><small>${text(x[2])}</small></div><span class="sync-state">${text("Pending")}</span></div>`).join("")}
    ${section("Connection") }<div class="content-card"><div class="settings-row"><span class="settings-glyph">●</span><strong>${text("Working offline")}</strong><span class="status-pill good">${text("Normal")}</span></div><p style="margin:8px 0 0;color:var(--muted);font-size:8px;line-height:1.6">${text("Records save securely on this device. They’ll sync automatically when your connection returns.")}</p></div><button class="button secondary full" data-action="sync-now">${text("Sync when connected")}</button>`);
}
function renderHeat() {
  return shell(`<div class="page-heading"><div><div class="heading-count">← ${text("Home")}</div><h1 class="section-title" style="margin-top:5px">${text("Heat Risk")}</h1></div><span class="status-pill urgent">${text("HIGH")}</span></div>
    <div class="heat-card"><div class="heat-top"><strong>${text("HIGH RISK")}</strong><span class="heat-temp">43°C</span></div><div style="display:flex;justify-content:space-between;color:#776d5c;font-size:9px;margin-top:7px"><span>28% ${text("humidity")}</span><span>14:20 · ${text("Today")}</span></div>
    <div class="heat-factors" style="margin-top:14px"><div class="heat-factor">${text("Temperature")}<b>↑ ${text("Very high")}</b></div><div class="heat-factor">${text("Water availability")}<b>⚠ ${text("Low flow")}</b></div><div class="heat-factor">${text("Handling risk")}<b>↑ ${text("High")}</b></div></div>
    <div class="recommend"><b>${text("Why this risk")}:</b> ${text("High air temperature, limited shade at North Pasture, and reduced trough flow combine to increase heat stress risk.")}</div></div>
    ${section("Recommended actions")}
    ${[["☂","Move to shade","North paddock shade available"],["💧","Check water","Inspect 3 troughs · North Pasture"],["↘","Avoid handling","Delay weighing and transport"],["◷","Recheck in 30 min","Reminder · 14:50"]].map(x=>`<div class="task-row"><span class="task-check"></span><div class="task-name">${text(x[1])}<small>${text(x[2])}</small></div><span class="chevron">${x[0]}</span></div>`).join("")}
    <button class="button full" style="margin-top:13px" data-action="heat-check">${text("Record heat check")}</button>`);
}
function renderBreeding() {
  const ewes=[["02 Oct","18 ewes","Group · Pregnant Ewes"],["08 Oct","12 ewes","Group · Dry Ewes"],["17 Oct","9 ewes","Group · North Flock"]];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Breeding")}</h1><div class="heading-count">${text("North Flock")} · ${text("2026 season")}</div></div><button class="icon-button" data-action="breeding-action">＋</button></div>
    <div style="display:flex;justify-content:space-between;align-items:center;margin:4px 0 12px"><strong style="font-size:11px">${text("September 2026")}</strong><div class="calendar-switch">${["Gregorian","Hijri"].map(x=>`<button class="${state.calendar===x?"active":""}" data-calendar="${x}">${text(x)}</button>`).join("")}</div></div>
    <div class="metric-grid"><div class="metric-tile"><strong>86</strong><span>${text("Pregnant ewes")}</span></div><div class="metric-tile"><strong>14</strong><span>${text("Expected this month")}</span></div></div>
    ${section("Expected lambing")}
    ${ewes.map(x=>`<div class="task-row"><div class="task-name"><strong>${text(x[0])}</strong> · ${text(x[1])}<small>${text(x[2])}</small></div><span class="chevron">›</span></div>`).join("")}
    ${section("Recent matings",`<button class="text-action" data-action="all-matings">${text("See all")}</button>`)}
    <div class="content-card"><div class="routine-row"><div><strong>#184 · Awassi Ewe</strong><small>${text("Mating")} · 08 Sep · ${text("Karakul #R12")}</small></div>${status("Confirmed","purple")}</div><div class="routine-row"><div><strong>#209 · Awassi Ewe</strong><small>${text("Mating")} · 06 Sep · ${text("Najdi #R04")}</small></div>${status("Confirmed","purple")}</div></div>
    ${section("Lambing tasks")}<div class="task-row" data-screen="tasks"><div class="task-name">${text("Prepare lambing pens")}<small>${text("Due 15 Oct")} · ${text("High")}</small></div><span class="chevron">›</span></div>`);
}
function renderEid() {
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Eid mode")}</h1><div class="heading-count">${text("Seasonal sale readiness")}</div></div><button class="icon-button" data-action="eid-filter">⌄</button></div>
    <div class="eid-countdown">☾ &nbsp;${text("Eid in 42 days")} <strong>· 26</strong> ${text("candidates")}</div>
    <div class="filter-row">${["All","Weight","BCS","Age","Health","Withdrawal"].map(x=>`<button class="filter-chip ${x==="All"?"selected":""}" data-filter="${x}">${text(x)}</button>`).join("")}</div>
    ${section("Sale readiness")}
    <article class="sheep-card" data-screen="overview"><div class="sheep-avatar">🐑</div><div class="sheep-info"><strong>#184 · Awassi</strong><small>${text("Ewe")} · 62 kg · ${text("BCS")} 3.0</small></div>${status("Healthy","good")}<div class="sheep-next">${status("CLEAR FOR SALE","good")} &nbsp;✓ ${text("No withdrawal")} &nbsp;✓ ${text("Health clear")}</div></article>
    <article class="sheep-card"><div class="sheep-avatar">🐑</div><div class="sheep-info"><strong>#209 · Awassi</strong><small>${text("Ram")} · 68 kg · ${text("BCS")} 3.5</small></div>${status("Withdrawal","withdrawal")}<div class="sheep-next"><span class="status-pill urgent">${text("NOT CLEAR FOR SALE")}</span> · ${text("5 days remaining")}</div></article>
    ${section("Readiness filters")}
    ${["Weight · 45–80 kg","BCS · 2.5–4.0","Age · 1 year or older","Health · no active conditions","Withdrawal · fully cleared"].map(x=>`<div class="task-row"><span class="task-check"></span><div class="task-name">${text(x)}</div><span class="chevron">›</span></div>`).join("")}`);
}
function renderMore() {
  const items=[["▦","Groups","groups"],["♧","Breeds",null],["✚","Medication",null],["☷","Regional protocols",null],["▤","Reports",null],["⌂","Farm settings",null],["⚙","Settings",null],["◉","Users",null],["↻","Sync center","sync"],["文","Languages",null],["▦","Calendar",null],["↔","Units",null],["☀","Field mode","field"]];
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("More")}</h1><div class="heading-count">${text("Farm tools and settings")}</div></div><div class="avatar">AN</div></div>
    <div class="content-card" style="display:flex;align-items:center;gap:10px"><div class="avatar">AN</div><div><strong style="font-size:10px">Ahmed Al Noor</strong><div style="margin-top:3px;color:var(--muted);font-size:8px">${text("Farm manager")} · ${text("Al Noor Farm")}</div></div><span class="chevron">›</span></div>
    ${section("Farm tools")}
    ${items.map(([i,n,s])=>`<div class="settings-row" ${s?`data-screen="${s}"`:"data-action='setting'"}><span class="settings-glyph">${i}</span><strong>${text(n)}</strong><span class="chevron">›</span></div>`).join("")}
    ${section("About HerdHub")}<div class="content-card"><div style="display:flex;justify-content:space-between;font-size:9px"><strong>HerdHub Sheep</strong><span style="color:var(--muted)">Version 1.4.2 · ${text("Offline ready")}</span></div></div>`);
}
function renderDesign() {
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Design system")}</h1><div class="heading-count">${text("Field-ready component library")}</div></div></div>
    ${section("Color by meaning")}<div class="design-swatches">${[["#1B4332","Forest"],["#606C38","Olive"],["#BC6C25","Terracotta"],["#F8F5F0","Cream"],["#AA3D31","Urgent"],["#72518A","Breeding"]].map(x=>`<div class="swatch" style="background:${x[0]};${x[0]==="#F8F5F0"?"color:#333;border:1px solid var(--line)":""}">${x[1]} · ${x[0]}</div>`).join("")}</div>
    ${section("Buttons")}<div class="component-buttons"><button class="button">${text("Primary action")}</button><button class="button secondary">${text("Secondary")}</button><button class="icon-button">＋</button></div>
    ${section("Status, not decoration")}<div style="display:flex;gap:6px;flex-wrap:wrap">${status("Healthy","good")}${status("Attention")}${status("Urgent","urgent")}${status("Breeding","purple")}${status("Withdrawal","withdrawal")}</div>
    ${section("Large number")}<div class="metric-grid"><div class="metric-tile"><strong>486</strong><span>${text("Total sheep")}</span></div><div class="metric-tile"><strong>43°</strong><span>${text("Heat Risk")} · ${text("HIGH")}</span></div></div>
    ${section("Touch-friendly BCS")}<div class="content-card"><div class="bcs-select">${["2.0","2.5","3.0"].map(n=>`<button class="${n==="2.5"?"selected":""}">${n}</button>`).join("")}</div></div>
    ${section("Offline & sync")}<div class="notice"><span>●</span>${text("Offline · Changes saved locally")}</div><div class="error-state" style="margin-top:8px">⚠ &nbsp; ${text("Something didn’t sync")}<br>${text("Your records are safe on this device.")}</div>
    ${section("Confirmation")}<div class="content-card" style="display:flex;gap:9px;align-items:center"><span class="confirm-mark" style="width:34px;height:34px;margin:0;font-size:16px">✓</span><strong style="font-size:10px">${text("47 records saved")}</strong></div>
    ${section("Sun mode")}<div class="content-card" style="border-width:2px"><button class="button full" data-action="set-sun">☀ &nbsp;${text("Activate Sun Mode")}</button></div>`);
}
function renderEmpty() {
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Flock")}</h1></div><button class="icon-button" data-action="add-sheep">＋</button></div><div class="empty-state"><div class="empty-icon">🐑</div><strong>${text("No sheep here yet")}</strong><p>${text("Add your first sheep and build your flock, one tag at a time.")}</p><button class="button small" data-action="add-sheep">＋ ${text("Add sheep")}</button></div>`);
}
function renderError() {
  return shell(`<div class="page-heading"><div><h1 class="section-title">${text("Sync center")}</h1></div></div><div class="error-state"><strong>${text("Something didn’t sync")}</strong><br>${text("Your records are safe on this device.")}</div><div class="content-card" style="margin-top:11px"><strong style="font-size:10px">${text("Connection unavailable")}</strong><p style="color:var(--muted);font-size:8px;line-height:1.5">${text("The last sync could not finish. Your saved records are safe and will retry when the connection is back.")}</p><button class="button secondary small" data-action="retry-sync">${text("Try again")}</button></div><div class="sync-item"><span>✓</span><div><strong>${text("Local records")}</strong><small>12 · ${text("Saved on this device")}</small></div><span class="sync-state">${text("Safe")}</span></div>`);
}
function renderField() {
  return `<div class="field-home"><div class="field-brand"><strong>HERDHUB · ${text("Field mode")}</strong><button class="icon-button" data-action="exit-field">×</button></div><div class="field-alert">⚠ &nbsp; 43°C · ${text("HEAT RISK · HIGH")}</div><div class="field-grid">${[["⌗","SCAN","scan"],["＋","LOG","quick"],["☷","TASKS","tasks"],["!","ALERTS","heat"]].map(x=>`<button class="field-button" data-screen="${x[2]}"><span>${x[0]}</span>${text(x[1])}</button>`).join("")}</div><div class="field-number"><span style="font-size:9px;color:var(--muted)">${text("Last scanned")}</span><strong>#184</strong><span style="font-size:10px">${text("BCS")} · 2.5</span></div><div style="font-size:10px;font-weight:700;margin:12px 0 5px">${text("Record condition")}</div><div class="bcs-select">${["2.0","2.5","3.0"].map(n=>`<button class="${n==="2.5"?"selected":""}" data-bcs="${n}">${n}</button>`).join("")}</div><button class="button full" style="min-height:54px;font-size:14px" data-action="save-bcs">${text("SAVE")}</button></div>`;
}
function render() {
  phone.dir=state.locale==="ar"?"rtl":"ltr";
  phone.className=`phone-screen ${state.mode==="dark"?"dark":state.mode==="sun"?"sun":state.mode==="field"?"field":""}`;
  const renderers={home:renderHome,flock:renderFlock,groups:renderGroups,scan:renderScan,overview:renderProfile,health:()=>{state.profileTab="health";return renderProfile()},breeding:()=>state.profileTab==="breeding"&&state.screen==="overview"?renderProfile():renderBreeding(),weight:()=>{state.profileTab="weight";return renderProfile()},timeline:()=>{state.profileTab="timeline";return renderProfile()},quick:renderQuick,treatment:renderTreatment,bulk:renderBulk,tasks:renderTasks,sync:renderSync,heat:renderHeat,eid:renderEid,more:renderMore,design:renderDesign,empty:renderEmpty,error:renderError,field:renderField};
  view.innerHTML=(renderers[state.screen]||renderHome)();
  nav.classList.toggle("hidden",state.mode==="field"||state.screen==="quick"||state.screen==="treatment"||state.screen==="bulk");
  renderNav(); renderScreenLinks();
  if(state.locale==="ar") document.documentElement.lang="ar"; else document.documentElement.lang="en";
}
function renderNav() {
  const items=[["home","⌂","Home"],["flock","◉","Flock"],["quick","+","Quick Log"],["tasks","☷","Tasks"],["more","···","More"]];
  nav.innerHTML=items.map(([key,glyph,label])=>`<button class="nav-item ${key==="quick"?"quick-nav":""} ${state.screen===key?"active":""}" data-screen="${key}"><span class="nav-glyph">${glyph}</span><span>${text(label)}</span></button>`).join("");
}
function renderScreenLinks() {
  linkList.innerHTML=Object.keys(screenNames).map(key=>`<button class="screen-link ${state.screen===key?"active":""}" data-screen="${key}">${title(key)}</button>`).join("");
}
function go(screen) { state.screen=screen; state.confirmation=false; if(screen==="health"||screen==="weight"||screen==="timeline") { state.profileTab=screen; state.screen="overview"; } if(screen==="breeding"&&state.profileTab!=="breeding") state.profileTab="breeding"; render(); view.scrollTop=0; }
function showToast(message) { const toast=document.getElementById("toast"); toast.textContent=text(message); toast.classList.add("show"); window.clearTimeout(showToast.timer); showToast.timer=window.setTimeout(()=>toast.classList.remove("show"),2200); }
function renderModal() {
  const actions=[["HEALTH",[["💊","Treatment"],["💉","Vaccination"],["🪱","Deworming"],["🧴","Dipping / parasite"],["🦶","Hoof trim"],["✂","Shearing"]]],["CONDITION",[["⚖","Weight"],["◉","BCS"],["🌡","Heat check"],["💧","Feed / water"]]],["BREEDING",[["♡","Mating"],["🐑","Pregnancy"],["🍼","Lambing"]]],["OTHER",[["▧","Photo"],["♬","Voice note"],["▤","Note"]]]];
  const backdrop=document.createElement("div"); backdrop.className="bottom-sheet-backdrop"; backdrop.id="quick-modal";
  backdrop.innerHTML=`<div class="bottom-sheet"><div class="sheet-handle"></div><h2 class="sheet-title">${text("What do you want to record?")}<button class="sheet-close" data-action="close-modal">×</button></h2><div class="notice"><span>●</span><span>#184 · ${text("Awassi")} ${text("Ewe")} · ${text("Last used")}: ${text("BCS")}</span></div>${actions.map(([h,items])=>`<div class="sheet-section"><h3>${text(h)}</h3><div class="sheet-grid">${items.map(([icon,name])=>`<button class="sheet-action" data-quick-action="${name}"><span>${icon}</span>${text(name)}</button>`).join("")}</div></div>`).join("")}</div>`;
  backdrop.addEventListener("click",e=>{if(e.target===backdrop){state.modal=false;backdrop.remove();}});
  phone.append(backdrop);
}
document.addEventListener("click",event=>{
  const target=event.target.closest("button,[data-screen],[data-action],[data-quick-action]");
  if(!target)return;
  if(target.dataset.screen){go(target.dataset.screen);return;}
  if(target.dataset.profileTab){state.screen="overview";state.profileTab=target.dataset.profileTab;render();return;}
  if(target.dataset.taskTab){state.taskTab=target.dataset.taskTab;render();return;}
  if(target.dataset.filter){state.filter=target.dataset.filter;render();return;}
  if(target.dataset.calendar){state.calendar=target.dataset.calendar;render();return;}
  if(target.dataset.bcs){document.querySelectorAll("[data-bcs]").forEach(b=>b.classList.remove("selected"));target.classList.add("selected");return;}
  if(target.dataset.quickAction){const action=target.dataset.quickAction;state.modal=false;document.getElementById("quick-modal")?.remove();state.screen=action==="Treatment"?"treatment":"treatment";state.confirmation=false;render();if(action!=="Treatment")showToast(`${action} · #184`);return;}
  switch(target.dataset.action){
    case "open-log": state.modal=true;renderModal();break;
    case "save-treatment":state.confirmation=true;render();break;
    case "save-bulk":state.confirmation=true;render();break;
    case "close-confirm":state.confirmation=false;go("home");showToast("Saved locally · Follow-up created");break;
    case "simulate-scan":state.scanFound=true;render();break;
    case "scan-next":state.scanFound=false;render();break;
    case "batch-scan":showToast("Batch scanning ready");break;
    case "sync-now":showToast("Syncing 12 changes…");setTimeout(()=>showToast("All changes synced"),1600);break;
    case "retry-sync":showToast("Still offline · Records are safe");break;
    case "save-bcs":showToast("BCS recorded · Saved locally");break;
    case "set-sun":state.mode="sun";modeSelect.value="sun";render();break;
    case "exit-field":state.mode="light";modeSelect.value="light";go("home");break;
    case "start-task":showToast("Task started · Saved locally");break;
    case "bulk-task":go("bulk");break;
    case "close-modal":state.modal=false;document.getElementById("quick-modal")?.remove();break;
    case "add-sheep":showToast("New sheep · Ready to add");break;
    case "new-group":showToast("New group · Select sheep");break;
    case "add-task":showToast("New task · Saved locally");break;
    case "setting":showToast("Farm settings");break;
    case "heat-check":showToast("Heat check recorded · Next check in 30 min");break;
    case "exceptions":showToast("All 47 sheep ready to vaccinate");break;
    case "edit":showToast("Edit sheep profile");break;
    case "share":showToast("Sheep profile actions");break;
    case "filter-tasks":showToast("Showing all priorities");break;
    case "eid-filter":showToast("Adjust sale-readiness filters");break;
    case "breeding-action":state.screen="quick";render();showToast("Choose a breeding record");break;
    case "all-matings":showToast("Showing recent matings");break;
    case "scan-tag":go("scan");break;
  }
});
modeSelect.addEventListener("change",()=>{state.mode=modeSelect.value; if(state.mode==="field")state.screen="field"; else if(state.screen==="field")state.screen="home";render();});
localeToggle.addEventListener("click",()=>{state.locale=state.locale==="en"?"ar":"en";localeToggle.innerHTML=state.locale==="ar"?"English <span>↗</span>":"العربية <span>↗</span>";render();});
document.addEventListener("input",e=>{if(e.target.id==="flock-search"){state.search=e.target.value;document.querySelectorAll(".sheep-card").forEach(card=>card.hidden=state.search&&!card.textContent.toLowerCase().includes(state.search.toLowerCase()));}});
render();
