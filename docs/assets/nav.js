/* =========================================================================
   NetBox LXC documentation — navigation + i18n (EN primary, SK secondary)
   ========================================================================= */

const GITHUB_URL = "https://github.com/ensecnet/NETBOX";

const NAV = [
  { group: "nav.group.start", items: [
    { key: "nav.overview", path: "index.html" },
    { key: "nav.deploy",   path: "pages/deploy.html" },
  ]},
  { group: "nav.group.ref", items: [
    { key: "nav.console", path: "pages/console.html" },
    { key: "nav.updates", path: "pages/updates.html", child: true },
  ]},
];

const I18N = {
  en: {
    "ui.switch": "SK",
    "ui.github": "View on GitHub",
    "nav.group.start": "Getting Started",
    "nav.group.ref": "Reference",
    "nav.overview": "Overview",
    "nav.deploy": "Deployment walk-through",
    "nav.console": "Appliance console",
    "nav.updates": "Updates & versions",
    "idx.lead": "Lightweight, reproducible deployment of NetBox (IPAM / Source of Truth) on Proxmox VE — one command on the node, an interactive wizard, then a semi-automatic deploy with current versions that ends in a SUCCESSFUL banner.",
    "idx.note.label": "No install needed to evaluate",
    "idx.note.body": "The walk-through covers the whole deploy with the exact commands and the real on-screen output — read it like a recording of the deployment.",
    "idx.toc": "Contents",
    "idx.card.deploy.tag": "Guide",
    "idx.card.deploy.t": "Deployment walk-through",
    "idx.card.deploy.d": "Step by step, from one line to SUCCESSFUL.",
    "idx.card.console.tag": "Reference",
    "idx.card.console.t": "Appliance console",
    "idx.card.console.d": "The status screen and menu that launch on login.",
    "idx.card.updates.tag": "Reference",
    "idx.card.updates.t": "Updates & versions",
    "idx.card.updates.d": "Version pinning and the auto-update timer.",
    "idx.oneline": "One command",
    "idx.oneline.body": "The node downloads the script, the wizard asks for configuration, and the rest runs semi-automatically.",
    "dep.crumb": "Deployment walk-through",
    "dep.title": "Deployment walk-through",
    "dep.lead": "The whole deploy, step by step, with real output. Network values are RFC 5737 placeholders (192.0.2.0/24).",
    "dep.s1": "1 \u00b7 One command on the Proxmox node",
    "dep.s1.body": "In the node shell (web UI \u2192 node \u2192 Shell, or SSH):",
    "dep.s1.note.label": "Prefer to read first?",
    "dep.s1.note.body": "git clone \u2192 less the script \u2192 run it. The script is short and readable.",
    "dep.s2": "2 \u00b7 The wizard",
    "dep.s2.body": "It asks for everything up front, defaults in brackets. Sequence: VMID, hostname, root password, NetBox admin (user/email/password), storage list + choice, disk/RAM/CPU, HTTP port, then network (bridge/IP/GW/DNS/VLAN) and versions (netbox-docker tag, auto-update). It ends with a summary and a single confirmation.",
    "dep.s3": "3 \u00b7 Semi-automatic deploy",
    "dep.s4": "4 \u00b7 SUCCESSFUL",
    "con.crumb": "Appliance console",
    "con.title": "Appliance console",
    "con.lead": "A status screen and management menu that launch automatically on login to the container (pct enter 310). Style: pfSense / OPNsense / Home Assistant OS.",
    "con.how": "What it looks like",
    "con.dots": "Status dots",
    "con.dots.body": "The dots next to services are colour-coded and live: green running, yellow starting, red stopped. State is read via docker ps on each render.",
    "con.install.label": "Install",
    "con.install.body": "The console is installed by the deployer to /usr/local/sbin/netbox-console.sh and launched via /etc/profile.d/ on interactive login. No commands to remember.",
    "upd.crumb": "Updates & versions",
    "upd.title": "Updates & versions",
    "upd.lead": "Two layers of update, kept separate — image versions and netbox-docker release pinning.",
    "upd.th.layer": "Layer", "upd.th.what": "What changes", "upd.th.how": "How",
    "upd.r1.l": "Images", "upd.r1.w": "NetBox / Postgres / Redis versions", "upd.r1.h": "Console option 3, or the weekly auto-update timer (if enabled)",
    "upd.r2.l": "Pinning", "upd.r2.w": "Which netbox-docker release you track", "upd.r2.h": "Run the deploy with a specific tag instead of release",
    "upd.timer": "Auto-update timer",
    "upd.timer.body": "If you enabled auto-update in the wizard, a systemd timer (netbox-update.timer) runs docker compose pull && up -d and a prune once a week. The path is idempotent — it recreates only changed containers; data in named volumes is untouched.",
    "upd.warn.label": "Production",
    "upd.warn.body": "For a controlled upgrade, pin a specific tag and turn auto-update off — change the version deliberately and tested, not automatically to whatever just shipped.",
    "pager.prev": "Previous", "pager.next": "Next",
    "footer": "NetBox LXC \u00b7 ensecnet \u00b7 reproducible Proxmox deployment"
  },
  sk: {
    "ui.switch": "EN",
    "ui.github": "Zobrazi\u0165 na GitHube",
    "nav.group.start": "Za\u010d\u00edname",
    "nav.group.ref": "Referencia",
    "nav.overview": "Preh\u013ead",
    "nav.deploy": "Postup nasadenia",
    "nav.console": "Appliance konzola",
    "nav.updates": "Aktualiz\u00e1cie a verzie",
    "idx.lead": "Od\u013eah\u010den\u00e9, reprodukovate\u013en\u00e9 nasadenie NetBoxu (IPAM / Source of Truth) na Proxmox VE \u2014 jeden pr\u00edkaz na node-e, interakt\u00edvny wizard, a poloautomatick\u00fd deploy s aktu\u00e1lnymi verziami, ktor\u00fd kon\u010d\u00ed v\u00fdpisom SUCCESSFUL.",
    "idx.note.label": "Netreba ni\u010d in\u0161talova\u0165 na vysk\u00fa\u0161anie",
    "idx.note.body": "Walk-through prejde cel\u00fd deploy s presn\u00fdmi pr\u00edkazmi a re\u00e1lnym v\u00fdstupom na obrazovke \u2014 d\u00e1 sa pre\u010d\u00edta\u0165 ako z\u00e1znam nasadenia.",
    "idx.toc": "Obsah",
    "idx.card.deploy.tag": "N\u00e1vod",
    "idx.card.deploy.t": "Postup nasadenia",
    "idx.card.deploy.d": "Krok za krokom od jedn\u00e9ho riadku po SUCCESSFUL.",
    "idx.card.console.tag": "Referencia",
    "idx.card.console.t": "Appliance konzola",
    "idx.card.console.d": "Status obrazovka a menu, \u010do sa spust\u00ed pri logine.",
    "idx.card.updates.tag": "Referencia",
    "idx.card.updates.t": "Aktualiz\u00e1cie a verzie",
    "idx.card.updates.d": "Pinovanie verzi\u00ed a auto-update timer.",
    "idx.oneline": "Jeden pr\u00edkaz",
    "idx.oneline.body": "Node stiahne skript, wizard sa sp\u00fdta na konfigur\u00e1ciu, a zvy\u0161ok prebehne poloautomaticky.",
    "dep.crumb": "Postup nasadenia",
    "dep.title": "Postup nasadenia",
    "dep.lead": "Cel\u00fd deploy krok za krokom s re\u00e1lnym v\u00fdstupom. Sie\u0165ov\u00e9 hodnoty s\u00fa RFC 5737 placeholdery (192.0.2.0/24).",
    "dep.s1": "1 \u00b7 Jeden pr\u00edkaz na Proxmox node-e",
    "dep.s1.body": "V shelli node-u (web UI \u2192 node \u2192 Shell, alebo SSH):",
    "dep.s1.note.label": "Rad\u0161ej najprv pre\u010d\u00edta\u0165?",
    "dep.s1.note.body": "git clone \u2192 less skript \u2192 spusti\u0165. Skript je kr\u00e1tky a \u010d\u00edtate\u013en\u00fd.",
    "dep.s2": "2 \u00b7 Wizard",
    "dep.s2.body": "P\u00fdta sa na v\u0161etko vopred, defaulty v z\u00e1tvork\u00e1ch. Sekvencia: VMID, hostname, root heslo, NetBox admin (user/email/heslo), v\u00fdpis storage + vo\u013eba, disk/RAM/CPU, HTTP port, potom sie\u0165 (bridge/IP/GW/DNS/VLAN) a verzie (netbox-docker tag, auto-update). Na konci s\u00fahrn a jedno potvrdenie.",
    "dep.s3": "3 \u00b7 Poloautomatick\u00fd deploy",
    "dep.s4": "4 \u00b7 SUCCESSFUL",
    "con.crumb": "Appliance konzola",
    "con.title": "Appliance konzola",
    "con.lead": "Status obrazovka a spr\u00e1vcovsk\u00e9 menu, ktor\u00e9 sa automaticky spust\u00ed pri prihl\u00e1sen\u00ed do kontajnera (pct enter 310). \u0160t\u00fdl pfSense / OPNsense / Home Assistant OS.",
    "con.how": "Ako vyzer\u00e1",
    "con.dots": "Stavov\u00e9 body",
    "con.dots.body": "Body pri slu\u017eb\u00e1ch s\u00fa farebn\u00e9 a \u017eiv\u00e9: zelen\u00fd running, \u017elt\u00fd starting, \u010derven\u00fd stopped. Stav sa \u010d\u00edta cez docker ps pri ka\u017edom zobrazen\u00ed.",
    "con.install.label": "In\u0161tal\u00e1cia",
    "con.install.body": "Konzolu nain\u0161taluje deployer do /usr/local/sbin/netbox-console.sh a cez /etc/profile.d/ ju spust\u00ed pri interakt\u00edvnom logine. \u017diadne pr\u00edkazy na zapam\u00e4tanie.",
    "upd.crumb": "Aktualiz\u00e1cie a verzie",
    "upd.title": "Aktualiz\u00e1cie a verzie",
    "upd.lead": "Dve vrstvy aktualiz\u00e1cie, dr\u017ean\u00e9 oddelene \u2014 verzie obrazov a pinovanie netbox-docker release.",
    "upd.th.layer": "Vrstva", "upd.th.what": "\u010co sa men\u00ed", "upd.th.how": "Ako",
    "upd.r1.l": "Obrazy", "upd.r1.w": "NetBox / Postgres / Redis verzie", "upd.r1.h": "Konzola vo\u013eba 3, alebo t\u00fd\u017edenn\u00fd auto-update timer (ak povolen\u00fd)",
    "upd.r2.l": "Pinovanie", "upd.r2.w": "Ktor\u00fd netbox-docker release sleduje\u0161", "upd.r2.h": "Spusti deploy s konkr\u00e9tnym tagom namiesto release",
    "upd.timer": "Auto-update timer",
    "upd.timer.body": "Ak si vo wizarde povolil auto-update, vytvor\u00ed sa systemd timer (netbox-update.timer), ktor\u00fd raz t\u00fd\u017edenne spust\u00ed docker compose pull && up -d a prune. Cesta je idempotentn\u00e1 \u2014 recreatne len zmenen\u00e9 kontajnery, d\u00e1ta v named volumes ost\u00e1vaj\u00fa netknut\u00e9.",
    "upd.warn.label": "Produkcia",
    "upd.warn.body": "Pre kontrolovan\u00fd upgrade pinuj konkr\u00e9tny tag a auto-update vypni \u2014 verziu me\u0148 vedome a otestovane, nie automaticky na to, \u010do pr\u00e1ve vy\u0161lo.",
    "pager.prev": "Predch\u00e1dzaj\u00face", "pager.next": "\u0104al\u0161ie",
    "footer": "NetBox LXC \u00b7 ensecnet \u00b7 reprodukovate\u013en\u00e9 nasadenie na Proxmox"
  }
};

(function () {
  const root = document.body.getAttribute("data-root") || "";
  const current = document.body.getAttribute("data-page") || "";
  function getLang(){ return localStorage.getItem("nbx-lang") || "en"; }
  function setLang(l){ localStorage.setItem("nbx-lang", l); apply(l); }
  function t(key, lang){ return (I18N[lang] && I18N[lang][key]) || I18N.en[key] || key; }
  function buildNav(lang){
    const sb=document.querySelector(".nav"); if(!sb)return; let h="";
    NAV.forEach(g=>{ h+=`<div class="nav-group"><div class="nav-group-title">${t(g.group,lang)}</div>`;
      g.items.forEach(it=>{ const c=[it.child?"child":"",it.path===current?"active":""].filter(Boolean).join(" ");
        h+=`<a href="${root}${it.path}" class="${c}">${t(it.key,lang)}</a>`; }); h+=`</div>`; });
    sb.innerHTML=h;
  }
  function apply(lang){
    document.documentElement.lang=lang;
    document.querySelectorAll("[data-i18n]").forEach(el=>{ el.textContent=t(el.getAttribute("data-i18n"),lang); });
    buildNav(lang);
    const sw=document.querySelector(".lang-switch"); if(sw) sw.textContent=t("ui.switch",lang);
    const gh=document.querySelector(".gh-link span"); if(gh) gh.textContent=t("ui.github",lang);
  }
  function injectExtras(lang){
    const brand=document.querySelector(".brand");
    if(brand && !document.querySelector(".lang-switch")){
      const b=document.createElement("button"); b.className="lang-switch"; b.type="button";
      b.textContent=t("ui.switch",lang);
      b.addEventListener("click",()=>setLang(getLang()==="en"?"sk":"en"));
      brand.appendChild(b);
    }
    const sidebar=document.querySelector(".sidebar");
    if(sidebar && !document.querySelector(".gh-link")){
      const a=document.createElement("a"); a.className="gh-link"; a.href=GITHUB_URL; a.target="_blank"; a.rel="noopener";
      a.innerHTML=`<svg viewBox="0 0 16 16" width="15" height="15" aria-hidden="true"><path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0016 8c0-4.42-3.58-8-8-8z"/></svg><span>${t("ui.github",lang)}</span>`;
      sidebar.appendChild(a);
    }
  }
  function mobileToggle(){
    const btn=document.querySelector(".menu-toggle"), sb=document.querySelector(".sidebar");
    if(btn&&sb){ btn.addEventListener("click",()=>sb.classList.toggle("open"));
      document.querySelectorAll(".nav a").forEach(a=>a.addEventListener("click",()=>sb.classList.remove("open"))); }
  }
  document.addEventListener("DOMContentLoaded",()=>{ const lang=getLang(); injectExtras(lang); apply(lang); mobileToggle(); });
})();
