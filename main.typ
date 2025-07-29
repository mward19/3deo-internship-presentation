#import "theme_3deo.typ": *

#let hr = align(center, line(length: 100%, stroke: gray))

#show: three-deo-theme.with(
  aspect-ratio: "16-9",
  navigation: "none",
  config-info(
    title: [Internship Project Report],
    subtitle: [],
    author: [Matthew Ward],
    date: [August 4, 2025],
    institution: []
  )
)
// #show link: it => underline(text(blue, it.body))
#show link: set text(blue)
#show link: underline
#show image: set align(center)

#let TeX = {
  set text(font: "New Computer Modern",)
  let t = "T"
  let e = text(baseline: 0.22em, "E")
  let x = "X"
  box(t + h(-0.14em) + e + h(-0.14em) + x)
}

#let LaTeX = {
  set text(font: "New Computer Modern")
  let l = "L"
  let a = text(baseline: -0.35em, size: 0.66em, "A")
  box(l + h(-0.32em) + a + h(-0.13em) + TeX)
}

#title-slide()


/*
Presentation is 30 minutes, 15 minutes for questions. Materials for next "job interview"... I wonder where? August 4th. They really want to know how I grew and what I learned. Sure, need some technical details, but there is time for questions.

Talk about
- What I did
- What I learned
- How I grew

What did I do?
- Pose graph optmization
- Kriging
- Registration metrics
- Spot modeling with truncated Gaussian
- PCA features
- Processing performance report
- Voxel spacing calculation for registration
  - GSOF reader
- Integration of code into Acadia (ground finder), containers

What did I learn?
- BFS not DFS when debugging. Wasted a day haha
- Don't get ahead of yourself while implementing code, stay open to new ideas. It's never finished. Registration, lie space stuff worked better
- Learned to deeply understand papers
- Working with other engineers, git adventures, coordinating and collaborating
- Operating like a surgeon on a large codebase - fix and test components
- Communicate constantly. Ask questions early and frequently

How did I grow?
- More patience working on a challenging problem. School doesn't give you time for that
- Better at working on other peoples' code. Make your code readable because _someone will read it_!
- More confidence learning new ideas and implementing them
- Gained some humility seeing Lawrence cook some stuff up way faster than I could haha

***
Format. Will talk about five or so experiences. Each time, discuss the goal, what I learned, and how I grew.

- Goal
- Knowledge
- Growth
*/

== Introduction
- BYU Applied and Computational Math (DS & ML, April 2026)
- Biophysics Simulation Group---computer vision and competition dataset curation
- Music
- Handball
- Data engineer intern with you until August 16#super[th]!

// #pause
// #v(2em)
// Future:


== Internship overview
Acadia-related work, no hardware yet.

Primarily point cloud registration and processing performance report, plenty more though.

#pause

---
#align(center + horizon)[#block(width: 60%)[
  *A few goals to discuss.*
  #set align(left)
  #set par(leading: 8pt, spacing: 16pt)
  1. Infer global registrations from pairwise registrations
  
  2. Model laser spot illumination as a Gaussian from sensor data

  3. Generate a processing performance report

  #v(2em)
]]

// #let placeGoal1 = place(top + right, dy: -1em, text(gray)[Infer global registrations from pairwise registrations])
// #let placeGoal2 = place(top + right, dy: -1em, text(gray)[Model laser spot illumination as a Gaussian from sensor data])
// #let placeGoal3 = place(top + right, dy: -1em, text(gray)[Generate a processing performance report])

// #focus-slide[
//   Format for what follows
//   #align(center)[#block(width: 80%)[
//     #set text(size: 24pt)
//     #grid(
//       [- Goal],      text(gray)[solve a problem, develop a module, etc.],
//       [- Approach],  text(gray)[what I did to achieve the goal],
//       [- Knowledge], text(gray)[new knowledge and skills],
//       [- Growth],    text(gray)[personal growth],
//       columns: 2,
//       row-gutter: 16pt,
//       column-gutter: 1em,
//       align: (left, left)
//     )
//   ]]
// ]

// #let goal-bullet(name, desc) = {
//   grid(
//     [*#name*], desc,
//     columns: (20%, auto),
//     align: top + left,
//     row-gutter: 40pt,
//     column-gutter: 1em
//   )
// }
// == Global registration

// /*
// Inferring global registrations. How to concisely explain global from pairwise registration? 

// Approach
// - pose graph optimization
// - modeling covariances
// - optuna hyperparameter search
// */

// #goal-bullet()[Goal][
//   Infer global registrations from pairwise registrations.

//   #pause

//   Straightforward to move one scan to align with another, less so to move $n$ scans to align with each other.

//   #pause

//   #align(center)[
//     #image("aux/graph-3-4.png", height: 40%)

//     Unfortunately, $macron(D)_13 != macron(D)_12 macron(D)_23.$
//   ]
// ]

// #meanwhile 

// ---


// #goal-bullet()[Approach][
//   Pose graph optimization.

//   #align(center)[
//     #image("aux/springs.png", height: 55%)
  
//     $
//       limits("minimize")_({X_1, ..., X_n}) quad &sum_(i, j) lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)^T 
//       C_(i j)^(-1) 
//       lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)
//     $
//   ]
// ]

// // Did a lot to try to determine the covariances, the stretchinesses.
// ---

// #goal-bullet()[Approach (cont.)][
//   Successful. Faster than existing methods, extensible to 6 DoF.

//   #pause

//   #align(center, text(size: 15pt)[_Barrett Park, pairwise registrations from `20250527_ncc`_])
//   #show image: set align(center)
//   #grid(
//     [
//       #image("aux/lu_milios_optimal_136.png") 
//       #align(center)[#text(size: 16pt)[Pose graph, constant covariance]]
//     ],  
//     [
//       #image("aux/nxn_optimal.png")
//       #align(center)[#text(size: 16pt)[Jacob Lawrence's `ncc_nxn.py`]]
//     ],
//     columns: (50%, 50%),
//     rows: (55%)
//   )
//   #v(2em)
// ]



// #pagebreak()
// #goal-bullet()[Knowledge][
//   - TODO
//   - TODO
// ]

// #goal-bullet()[Growth][
//   - Let go
// ]

// #meanwhile 


// == Spot illumination modeling
// #goal-bullet()[Goal][Model laser spot illumination as a Gaussian from sensor data.]

== Global registration from pairwise registration

#pause
// Goal

Straightforward to move one scan to align with another, less so to move $n$ scans to align with each other.

#align(center)[
  #image("aux/graph-3-4.png", height: 40%)

  Unfortunately, $macron(D)_13 != macron(D)_12 macron(D)_23.$
]

---

// Approach
Pose graph optimization.

// This is what I spent my first couple weeks learning about. Reading papers. Lots of statistics things.

#align(center)[#image("aux/springs.png", height: 55%)]

// Hardest part is setting covariances

$
  limits("minimize")_({X_1, ..., X_n}) quad &sum_(i, j) lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)^T 
  C_(i j)^(-1) 
  lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)
$
---

Pose graph optimization.


#grid(
  image("aux/springs.png", height: 55%),
  [
    - Constant stretchiness // this works pretty well, and even to the present it's what we're using
    - Model stretchiness manually. $(i, j) -> C_(i j)^(-1)$ // not so good
    - Model stretchiness with machine learning (Optuna) // promising but incomplete and probably not necessary
  ],
  columns: (50%, 50%),
  align: (center + horizon, left + horizon),
  column-gutter: 1em,
  inset: (x: 1em)
)

$
  limits("minimize")_({X_1, ..., X_n}) quad &sum_(i, j) lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)^T 
  C_(i j)^(-1) 
  lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)
$

---

Pruning and weighting.

#grid(
  image("aux/error_z_all.png", height: 75%),
  [
    - After optimization, some springs (pairwise registrations) are stretched
    - Lots of redundancy in the graph reveals poor pairwise registrations
    - Weight those springs less or remove
  ],
  columns: (50%, 50%),
  align: (center + horizon, left + horizon),
  column-gutter: 1em,
  inset: (x: 1em)
)


// We have found success applying constant covariances. As long as most of the springs are right, the bad registrations will get "tight" and we can remove them. We can prune, we can downweight. Iterative least squares. Add a bit about this. IRLS, iteratively reweighted least squares. Trying to not let model skew. 

/* 
Knowledge:
  - Refined programming skills, put to the test my ability to implement mathematics. Implemented a paper and learned to work slowly. Just a couple weeks ago we caught another mistake in my initial implementation! 
  - Modeling skills. Had to think deeply about that model and how I might use machine learning to optimize it. Would love to come back to this, but I don't think it's necessary for excellent registrations right now.
  - Point cloud wrangling, viewing, comprehension of how long it takes to do things with this data
  
Growth
- Patience to read a dense paper and understand it deeply enough to apply it to a new context
- Patience to work through challenging questions when there isn't a "teacher" available to give me the answers
*/

== Spot modeling

// Story behind spot modeling. Tracking and modeling the laser spot during scanning. Useful to analyze reflectivity. If we can track the spot, we can track how much light we probed a certain area with and get a good reflectivity estimate. Can be used for validation of proper alignment. Emphasize it was an exploration. Success! Could be useful for a few things. Good for QC, refine tx rx alignment. Lots of auto QC possibilities. A new way to look at the data. 
/*
- Ask how people think it might be useful for QC.
  - Pixel map is useful. Track pixels that are bugging out. 
  - Non-invasive. Can be done during flight operations. Doesn't require a certain scan pattern. 
  - Measure spot size. 
  - Track beam divergence.
*/

// TODO: get visuals from Lawrence of "banding". Just get a scan from hafb.
#align(center)[
  #set text(size: 18pt)
  Analyzing `20230627_095732_cuchillo1_scan00091.bpf`
]
#place(horizon + center, dy: 7%, image("aux/scan91_z.png", height: 80%))
---
#place(horizon + center, dy: 6%, image("aux/spot.png", height: 95%))
---
#place(horizon + center, dy: 6%, dx: 0%, image("aux/avg_hitmap.png", height: 95%))
#align(left)[
  #set text(size: 22pt)
  Total *photon detections per pixel* during \
`20230627_095732_cuchillo1_scan00091.bpf`
]
---

#align(center)[
  #set text(size: 18pt)
  Analyzing `20230627_095732_cuchillo1_scan00091.bpf`
]

#align(center)[
  #block()[
    #set align(left)
    // It moves back and forth with each swipe
    - #link("aux/hitmap_moving_average_window_30.mp4")[30 frame moving average pixel hitmap]
    // Modeling with GMMs doesn't work because the data is truncated
    - #link("aux/spot_movement_window_100_gaussians_1.mp4")[Model with Gaussian Mixture Model (1 component)]
    // GMMis works great
    - #link("aux/spot_movement_window_100_gaussians_1_new_gmmis_1_in_1.mp4")[Model with GMMis]
    - #link("aux/spot_movement_window_100_gaussians_1_gmmis_1_in_100.mp4")[Model with GMMis, keep only 1% of detections] // Useful for integrating in the processing chain. 
  ]
  #hr

  // How many frames are we averaging? How am I averaging? Why am I averaging the way I am? Modeling frame by frame or what, or is it filtering?
  
  #place(bottom + center, dy: -10%)[#image("aux/avg_hitmap_pixels_only.png", height: 25%)]
]

// Lots of fun. Got to try many approaches. Successfully applied GMMs and time series skills to this fun problem. Can be used to get a better pointwise density feature.

---

// Talk about PyMC forum. Growth. Learning to ask questions. What I was trying to do wasn't implemented. Even pointed me to the relevant pull request.
#align(center + horizon)[#image("aux/forum-pymc.png", height: 80%)]

== Processing performance report
#place(horizon+center, grid(
  [
    Not to be confused with sensor performance report!

    #pause

    A consise, readable aux/.pdf report summarizing key insights from processing.

    #set text(size: 18pt)
    Located in #text(gray)[`acadia-output-directory/`]`qc/processing_report`
  ],
  image("aux/thumbnail-report.png", height: 100%),
  image("aux/thumbnail-report-mapping.png", height: 100%),
  columns: (60%, 10%, 10%),
  align: horizon + left,
  gutter: 1em
))
---
// Show an example report. ~/Downloads/leidos_report/aux/processing_report.pdf
#image("aux/vulcan_mapping_top.png", height: 80%)
// #align(center)[
//   #link("aux/processing_report.pdf")[Single target report]

//   #link("aux/processing_report_mapping.pdf")[Vulcan mapping run report]
// ]
//
---
#place(horizon+center, dy: 20pt, image("aux/scans-overview.png", height: 88%))
---
#place(horizon+center, dy: 16pt, image("aux/processing-example.png", height: 88%))
---
#place(horizon+center, dy: 16pt, image("aux/processing-timeline.png", height: 60%))
---
#place(horizon+center, dy: 16pt, dx: 0%, image("aux/hafb-view.png", height: 80%))
---
#place(horizon+center, dy: 16pt, dx: 0%, image("aux/hafb-view.png", height: 80%))
#place(horizon+center, dy: 0pt, dx: 23%, image("aux/hafb-page.png", height: 100%))
---
#place(horizon+center, image("aux/rejections.png", height: 30%))
---
#align(center + horizon, grid(
  [
    #link("aux/processing_report.pdf")[Single target report] \
    #image("aux/thumbnail-report.png", height: 70%)
  ],
  [
    #link("aux/processing_report_mapping.pdf")[Mapping report] \
    #image("aux/thumbnail-report-mapping.png", height: 70%)
  ],
  columns: (40%, 40%),
  align: (center, center)
))
---

#align(center + horizon)[
  #let arrow = rotate(math.arrow.long, 90deg)
  Processing directory \
  #text(gray, size: 14pt)[say, `albert:/shares/processed/cuchillo/flightData/FlatCreek`]
  
  #arrow 
  
  .json of filepaths and statistics \
  #text(gray, size: 14pt)[to be used in report]
  
  #arrow
  
  #LaTeX report
  #arrow

  aux/.pdf report
]

---


/*
Describe what it is

Compare to the sensor performance report

Show an example

What I learned, data stuff, code architecure, how does it work. 
*/


/*
Have a good beginning and good end. Spend more time on processing report, but keep it at the end.

Registration was more or less exploratory. Became a lot more important when we wanted to implement rotations. The lie stuff came out of it. Impact! Discuss impact!

Also, where is the result, where is the code? Link all info here. 
*/