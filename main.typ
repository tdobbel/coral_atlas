#import "@preview/starter-journal-article:0.3.2": article, author-meta
#set par(justify: true)
#set par.line(numbering: n => text(size: 8pt, font: "Agave Nerd Font Mono")[#n])
#set page(numbering: "1")
#show figure: set par.line( numbering: none )
#show bibliography: set par.line( numbering: none)
#show footnote.entry: set par.line( numbering: none)
#let citet(..citation) = cite(..citation, form: "prose")
#let citealp(..citation) = [#cite(..citation, form: "author"), #cite(..citation, form: "year")]

#let modif(content) = {
  set text(blue)
  [#content]
}

#show: article.with(
  title: "Decadal and multispecies coral connectivity modeling for conservation and restoration prioritization in Florida",
  authors: (
    "Thomas Dobbelaere": author-meta(
      "elie",
      email: "thomas.dobbelaere@uclouvain.be",
    ),
    "Ryan Chabotte": author-meta(
      "nova",
    ),
    "Joana Figueiredo": author-meta(
      "nova"
    ),
    "Daniel M Holstein": author-meta(
      "lsu", "sbu"
    ),
    "Emmanuel Hanert": author-meta(
      "elie", "immc"
    ),
  ),
  affiliations: (
    "elie": "Earth and Life Institute (ELI), Université catholique de Louvain, Louvain-la-Neuve, Belgium",
    "nova": "National Coral Reef Intitute, Nova Southeastern University, Dania Beach, FL, USA", 
    "lsu": "Department of Oceanography and Coastal Sciences, College of the Coast and Environment, Louisiana State University, Baton Rouge, LA, USA",
    "sbu": "Department of Biology, Stony Brook University, Stony Brook, NY, USA",
    "immc": "Institute of Mechanics, Materials and Civil Engineering (iMMC), Université catholique de Louvain, Louvain-la-Neuve, Belgium",

  ),
  abstract: [
  Coral populations are rapidly declining due to global warming and local anthropogenic stressors, with nearly all living corals at risk if temperatures rise beyond 1.5°C. As reversing climate change is no longer feasible, effective local actions are essential to mitigate its impacts and support coral recovery through targeted restoration and protection efforts. Biophysical models that simulate coral larval dispersal at reef-scale resolution are crucial for guiding these actions. However, the high computational cost of such models has limited most studies to a few species and spawning events, lacking insights into interannual and interspecific variability. Here, we used the multi-scale ocean model SLIM to simulate larval dispersal for six key reef-building coral species (_Diploria labyrinthiformis_, _Acropora cervicornis_, _Pseudodiploria strigosa_, _Colpophyllia natans_, _Montastraea cavernosa_, and _Orbicella faveolata_) across Florida's Coral Reef over a 10-year period (2012–2021), incorporating experimentally calibrated larval dynamics. Our results show that connectivity indicators are most strongly correlated among species with similar spawning windows. Notably, the weighted in- and out-degrees exhibited the highest interspecific and interannual correlations. By integrating these metrics into a restoration indicator, we identified large clusters of reefs in the Dry Tortugas and northern Broward-Miami regions with significant restoration potential. The in- and out-degrees displayed limited interannual variability, with most fluctuations observed at outer shelf reefs in the Lower Keys and Dry Tortugas, where the ocean circulation is more variable. By providing long-term connectivity estimates for multiple reef-building species, this study offers valuable insights to inform marine conservation strategies.
  ],
  keywords: ("Florida's Coral Reef", "Biophysical modeling", "Connectivity", "Interannual and interspecific coral variability"), 
  bib: bibliography("./biblio.bib")
)

= Introduction

Coral reefs are complex and biodiverse ecosystems that for the past decades have been facing multiple stressors leading to their global decline. This rapid decline is due to direct and indirect anthropogenic stressors, such as climate change, nutrient and sediment run-off, overharvesting of herbivores and pollution @hughes2003climate @hughes2018spatial @hoegh2007coral @hoegh2017coral. Increased frequency and intensity of disturbances, such as heat events and disease, decrease coral fecundity and often leads to mortality. When adult coral density is low, it becomes less likely that the eggs of a colony will meet the sperm of another colony, reducing fertilization success and consequently the number of larvae that could recruit and replenish populations. Larval settlement success and post-settlement survival and growth are also reduced due to increased sedimentation, turf and macroalgae overgrowth and high frequency of heat disturbances @tuttle2022effects. As a result, many reefs around the world, such as the Florida’s Coral Reef (FCR), have lost resilience and no longer fully recover following acute disturbances @jones2022frequent.

As an infamous hotspot for coral disease, the Caribbean has already experienced a 50-80% decline of live coral cover since the 1970s @gardner2003long @jackson2014status. Furthermore, the Caribbean is currently experiencing an outbreak of the stony coral tissue loss disease (SCTLD), one of the most pervasive and virulent coral diseases on record, which affects over 22 species of reef-building corals @walton2018impacts @hayes2022tissue. This disease was first observed off the coast of Miami in 2014 @precht2016unprecedented, and has since then decimated coral populations throughout the entirety of Florida's Coral Reef (FCR) @williams2021fine @hayes2022tissue @frrp2021. As a consequence, coral cover in Southeastern Florida has now dropped below 1%, while reefs in the Florida Keys maintained a cover of roughly 6% @grove2022national. However, extreme warm events have increased significantly in the Florida Keys in recent decades and culminated in 2023 with massive die-off @neely2024too and, if trends persist, annual bleaching could occur in the region before 2034 @manzello2015rapid. Besides, Florida is a prime landfall target for hurricanes, which are expected to increase in intensity under climate change @dobbelaere2024hurricanes. It becomes thus urgent to maintain coral populations and support their recovery through restoration and conservation efforts.

Connectivity-informed coral restoration can directly repopulate small reef areas but, if environmental conditions are favorable, also indirectly accelerate natural processes of recovery through sexual reproduction and recruitment on neighbouring reefs. When genetically different corals are outplanted on the reef in close proximity, it increases the chances their gametes will get fertilized @omori2019coral. Moreover, if restoration site selection is focused on reefs that distribute larvae to a greater number of farther, unrestored reefs (termed source reefs, #citealp(<bode2018resilient>)) due to local currents @king2023larval, it could (if local environmental conditions were favorable) hasten reef recovery and the broader resilience to disturbances. Reef connectivity, and thus the location of source reefs within a reef system, can be determined using biophysical models of coral larval dispersal @frys2020fine @figueiredo2022global @holstein2014consistency @holstein2022predicting @king2023larval. These models use high-resolution (multi-year) ocean circulation dynamics and empirically calibrated larval dynamics, specifically larval survival (how long larvae remain alive for) and competency (when larvae become ready to settle and metamorphose into a coral polyp and when this ability is lost), to predict larval dispersal and settlement within a reef system. #modif[Therefore, the accuracy of these models depends heavily on larval dynamics, which can be described using laboratory observations @limer2024life.]

Understanding reef connectivity is also important to determine where to place marine protected areas (MPAs), identify areas which are more vulnerable to disturbance (by being less connected to upstream reefs and hence with fewer chances to be repopulated by them), and areas which are more resilient (well-connected). Interspecific differences in larval survival and competency determine the species’ tendency to either settle on their natal reef (local retention, a measure of reef’s self-persistence) and/or disperse long-distances, potentially recolonizing distant reefs thus increasing the connectivity and genetic diversity of its populations. At the reef level, having high levels of local retention (proportion of larvae produced by a reef that settled back on that reef) means this reef has a higher ability of self-replenishment. If a reef has high self-recruitment (proportion of the settlers on a reef that originated from larvae produced on that reef) it means it is highly isolated.  Although more shielded from human influence, isolated reefs are more susceptible to larger perturbations such as severe storms or oil spills @baumann2022remoteness because if disturbed they are rarely replenished by larvae coming from other locations. Sink reefs, _i.e._ reefs which receive larvae from many other reefs, have a high network persistence and are expected to recover faster following disturbances. Source reefs are optimal locations for marine resource managers to prioritize for protection; the preservation of source reef through marine reserves or MPAs ensures larval supply at both local and regional scales @muenzel2023integrating, contributing to the resilience of entire reef system.

As biophysical models used to estimate reef connectivity at a fine spatial scale typically require significant computational resources, most connectivity studies cover thus a limited number of spawning events and coral species. This undermines the robustness of the derived connectivity estimates, as they lack interannual and interspecific variability. In this study, we fill in this gap by simulating the dispersal of larvae from six key reef-building coral species of Florida over 10 consecutive years (2012-2021). Using these 10 years of simulation, we identify consistent connectivity hotspots and strongly connected reef clusters for all simulated years and species. Furthermore, by identifying pairs of coral species with strongly correlated connectivity metrics, we highlight the potential for coupled management strategies.

= Methods

This study follows a multidisciplinary approach that integrates experimental measurements, numerical modelling, and network analyses. First, we quantified key larval traits through controlled experiments on six reef-building coral species. These empirically calibrated traits were then incorporated into a high-resolution biophysical model to simulate potential larval connectivity during mass spawning events over ten consecutive years. Finally, we analyzed the resulting connectivity networks using graph theory and statistical methods to quantify interannual and interspecific variability and identify reefs most suitable for restoration.

== Larval survival and competency dynamics


We experimentally calibrated the larval survival and competency of six key reef-building Caribbean coral species that were strongly impacted by SCTLD: _Diploria labyrinthiformis_, _Acropora cervicornis_, _Pseudodiploria strigosa_, _Colpophyllia natans_, _Montastraea cavernosa_, and _Orbicella faveolata_. Larvae were obtained through successful induction of gonad maturation and synchronous spawning ex situ at Nova Southeastern University, Florida Aquarium, and University of North Carolina Wilmington. #modif[_Montastraea cavernosa_], the only gonochoric species studied, had sperm collected using a 25 mL pipette, ensuring the necessary higher concentration of sperm for fertilization @fogarty2012asymmetric @fogarty2012weak @dela2020optimising. Eggs were collected from the water surface and mixed with the sperm for fertilization. Hermaphroditic species released both eggs and sperm in bundles. Bundles were collected at the surface of the water and put into fertilization bowls with seawater to attain the concentration of #modif[$10^6$] sperm cells/mL known to maximize fertilization @fogarty2012asymmetric @fogarty2012weak @dela2020optimising. Fertilization success was confirmed by observing embryos undergoing cell division. Embryos were then washed to remove unused sperm and ensure a clean culture. _#modif[Acropora] cervicornis_ gametes were collected from sexually mature colonies off Fort Lauderdale, while _O. faveolata_ gametes were obtained from Biscayne Bay National Park. The other species were kept in aquaria year-round and induced to spawn in the lab. #modif[For each species, to] assess larval survival, 400 fertilized embryos were equally distributed into four 200 mL jars at a constant temperature of 28°C, and monitored daily under a microscope. The water was exchanged daily, and larvae were washed and placed into clean jars until all had died. For larval competency, once larvae were observed rotating, #modif[_ca._] 3,500 larvae were randomly divided into three bowls kept at a constant temperature of 28°C and aerated to prevent settlement and anoxic conditions. Daily, 40 larvae from each species were placed into #modif[ 4 replicate jars (10 larvae/jar) ] with aragonite tiles with crustose coralline algae, and checked for settlement and metamorphosis after 24h using a microscope. Competency trials were repeated daily until all larvae had died. Larval survival and competency dynamics for each species were modelled using the methodology described by #citet(<figueiredo2022global>), with detailed methods in their online supplementary information.

== Larval dispersal and connectivity modeling

We simulated the hydrodynamics over the #modif[entire] FCR during 10 years (2012-2021) with the multi-scale ocean circulation model SLIM#footnote("https://www.slim-ocean.be"). This model has already been successfully validated and applied in Florida to simulate the dispersal of larvae and disease agents @frys2020fine @dobbelaere2020coupled @dobbelaere2022connecting @king2023larval. SLIM uses an unstructured mesh whose resolution can be locally refined in order to represent flow features down to the reef scale (@fig:mesh). The model mesh was generated using the seamsh#footnote(link("https://github.com/alcoat/seamsh")) Python library, based on the open-source mesh generator GMSH @geuzaine2009gmsh. It was made up of about $6,6 times 10^5$ triangles, whose size ranged from $~50$ m near reefs to $~10$ km further offshore. The mesh element size was refined based on the distance to reefs and coastlines, as well as the bathymetry and bathymetry gradient. SLIM currents were relaxed towards the operational Navy HYbrid Coordinate Ocean Model (HYCOM; #citealp(<chassignet2007hycom>)) following the approach of #citet(<dobbelaere2022impacts>) to capture the baroclinic dynamics of the Florida Current. Further details about the model formulation can be found in #citet(<frys2020fine>).

#figure(
  image("figures/fig_mesh_tnc.png", width: 95%),
  caption: [Model mesh (*A*) and bathymetry (*B*) with close-up views of the simulated currents in the Dry Tortugas (*C*) and the Marquesas Keys (*D*). The different regions of Florida's Coral Reef, as defined in the Unified Reef Map are shown in panel (*B*). This illustrates the ability of the model to capture complex fine-scale flow patterns near reefs and islands. Land is shown in light grey, reefs in dark grey, and reef sub-regions with live corals are represented by blue squares.]
)<fig:mesh>
