/* NetBox LXC documentation navigation. */
const NAV = [
  { group: "Getting Started", items: [
    { title: "Overview",        path: "index.html" },
    { title: "Deployment walk-through", path: "pages/deploy.html" },
  ]},
  { group: "Reference", items: [
    { title: "Appliance console", path: "pages/console.html" },
    { title: "Updates & versions", path: "pages/updates.html", child: true },
  ]},
];
(function(){
  const root=document.body.getAttribute("data-root")||"";
  const cur=document.body.getAttribute("data-page")||"";
  function build(){const sb=document.querySelector(".nav");if(!sb)return;let h="";
    NAV.forEach(g=>{h+=`<div class="nav-group"><div class="nav-group-title">${g.group}</div>`;
      g.items.forEach(it=>{const c=[it.child?"child":"",it.path===cur?"active":""].filter(Boolean).join(" ");
        h+=`<a href="${root}${it.path}" class="${c}">${it.title}</a>`;});h+=`</div>`;});sb.innerHTML=h;}
  function mt(){const b=document.querySelector(".menu-toggle"),s=document.querySelector(".sidebar");
    if(b&&s){b.addEventListener("click",()=>s.classList.toggle("open"));
      document.querySelectorAll(".nav a").forEach(a=>a.addEventListener("click",()=>s.classList.remove("open")));}}
  document.addEventListener("DOMContentLoaded",()=>{build();mt();});
})();
