#import "theme_3deo.typ": *

#let hr = align(center, line(length: 100%, stroke: gray))
#let arrow = rotate(math.arrow.long, 90deg)

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

#show link: set text(blue)
#show link: underline
#show image: set align(center)

#let TeX = {
  set text(font: "New Computer Modern", weight: "medium")
  let t = "T"
  let e = text(baseline: 0.22em, "E")
  let x = "X"
  box(t + h(-0.14em) + e + h(-0.14em) + x)
}

#let LaTeX = {
  set text(font: "New Computer Modern", weight: "medium")
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
#align(center + horizon, grid(
  [- BYU Applied and Computational Math (DS & ML, April 2026)], image("aux/acme.jpg", height: 20%),
  [- Biophysics Simulation Group---computer vision and competition dataset curation with 3D pictures of bacteria (cryo-ET tomograms)], image("aux/byu-kaggle-logo.png", height: 20%),
  [- Data engineer intern with you until August 16#super[th]!], image("aux/3DEO_Logo_Huge.png", height: 30%),
  columns: (auto, 30%),
  align: (left + horizon, center + horizon),
  row-gutter: 1em
))


// #pause
// #v(2em)
// Future:


== Overview of projects
#align(center + horizon)[#block(width: 60%)[
  #set align(left)
  #set par(leading: 8pt, spacing: 16pt)

  1. Generate a processing performance report

  2. Improve registration pipeline with pose graph optimization
  
  3. Model laser spot illumination as a Gaussian from sensor data

  #v(2em)
]]

#focus-slide()[Processing Performance Report]

== Processing Performance Report
#place(horizon+center, grid(
  [
    Not to be confused with sensor performance report!

    #pause

    A PDF report summarizing key insights from processing.

    #text(size: 18pt)[
      Located in #text(gray)[`<acadia-output-directory>/`]`qc/processing_report` after processing is complete
    ]
  ],
  image("aux/thumbnail-report.png", height: 100%),
  columns: (75%, 10%),
  align: horizon + left,
  gutter: 1em
))
---
#place(horizon+center, grid(
  [
    #align(center)[Report Format]
    #let clarification(input) = text(gray, size: 16pt, input)

    - #text(olive)[Contents]
    - #text(red)[Overview] (information about all tiles together)
    - #text(blue)[Tile 1] (information specific to this tile)
    - #text(blue)[Tile 2]
    - #text(blue)[#math.dots.v]
    - #text(blue)[Tile $n$]
  ],
  image("aux/thumbnail-report.png", height: 100%),
  columns: (75%, 10%),
  align: horizon + left,
  gutter: 1em
))
#let brace(color) = {
  set text(weight: "thin", font: "Libertinus Serif", fill: color)
  [{]
}

#place(bottom + right, dx: -17%, dy: -89%, scale(x: 300%, y: 400%, brace(olive)))
#place(bottom + right, dx: -17%, dy: -58%, scale(x: 300%, y: 800%, brace(red)))
#place(bottom + right, dx: -17%, dy: -22%, scale(x: 300%, y: 450%, brace(blue)))
#place(bottom + right, dx: -16%, dy: -3%, scale(100%, text(blue)[#math.dots.v]))

== Processing Report Generation Process
#align(center + horizon)[
  Processing directory \
  #text(gray, size: 14pt)[say, `albert:/shares/processed/cuchillo/flightData/FlatCreek`]
  
  #arrow 
  
  JSON of filepaths and statistics \
  #text(gray, size: 14pt)[to be used in report]
  
  #arrow
  
  #LaTeX report
  #arrow

  PDF report
]

== Example Processing Reports
#align(center + horizon, grid(
  [
    #link("aux/processing_report.pdf")[Single Tile Report] \
    #image("aux/thumbnail-report.png", height: 70%)
    #text(black, size: 20pt, weight: "medium")[(6 pages)]
  ],
  [
    #link("aux/processing_report_mapping.pdf")[Mapping Report (56 tiles)] \
    #image("aux/thumbnail-report-mapping.png", height: 70%)
    #text(black, size: 20pt, weight: "medium")[(203 pages)]
  ],
  columns: (50%, 50%),
  align: (center, center)
))

== Overview
#place(left + horizon, dx: 50pt)[
    #let clarification(input) = {
      h(1em)
      text(gray, size: 16pt, input)
    }
    - Processing summary \
      #clarification()[How long processing took, CPU time, etc.]
    - Scan summary \
      #clarification()[Number of detections, how long scanning took, etc.]
  ]

#place(horizon + right, dx: -100pt, image("aux/processing_report_overview.png"))
#place(
  horizon + right,
  dx: 35pt,
  rotate(90deg, text(weight: "medium", size: 16pt)[
    (Overview from Single Tile Report)
  ])
)

== Processing Summary
#place(horizon+center, dy: 16pt, image("aux/processing-example.png", height: 88%))
== Processing Timeline
#place(horizon+center, dy: 16pt, image("aux/processing-timeline.png", height: 60%))

== Per Tile Sections
#place(left + horizon, dx: 50pt)[
    #let clarification(input) = {
      h(1em)
      text(gray, size: 16pt, input)
    }
    - Picture of the tile
    - Scan information \
      #clarification()[Number of detections, how long scanning took, etc.]
    - Rejected data \ 
      #clarification()[Reasons for rejection]
    - Registration information \ 
      #clarification()[To evaluate success of registration]
  ]

#place(horizon + right, dx: -100pt, image("aux/processing_report_tile.png"))
#place(
  horizon + right,
  dx: 65pt,
  rotate(90deg, text(weight: "medium", size: 16pt)[
    (HAFB_tieline_019 from Single Tile Report)
  ])
)

== Future Work
- Continue to refine wording and format for clarity
- Finish implementing fields
  - Scan density information
  - Report on more data rejection reasons
  - Registration success metrics
  - Warnings---for example, warn if the beam was dumping
- Get client feedback---what do they want to see in the report?
- Make #LaTeX compilation container smaller

// ---
// #place(horizon+center, dy: 16pt, dx: 0%, image("aux/hafb-view.png", height: 80%))
// #place(horizon+center, dy: 0pt, dx: 23%, image("aux/hafb-page.png", height: 100%))
// #block(width: 30%, inset: 1em)[
//   - 
// ]

#focus-slide()[Pose Graphs for Registration]
== Ghosting
#align(horizon+center, {
  grid(
  [Good registration], image("aux/roof_nxn.png", height: 90%),
  [Bad registration \ #text(gray, size: 14pt)[notice that the roof is doubled here]], image("aux/roof_model.png", height: 90%),
  rows: (43%, 43%),
  columns: (auto, 50%),
  align: (right, left)
)})

== Scan Poses
#place(center + horizon, dy: 8%, image("aux/pairwise registration_annotated-4.png", height: 95%))
#place(center + horizon, dx: 105pt, dy: -120pt, text(size: 22pt, weight: "medium")[Starting Poses])

== Pose Graph

We have ways to move one scan to align with another, with some uncertainty. How can we move $n$ scans to align with each other?

#v(2em)

#align(center, grid(
  image("aux/graph-3-4.png", height: 40%),
  [
    In practice, $macron(D)_13 != macron(D)_12 macron(D)_23.$
  ],
  columns: (30%, auto),
  align: left + horizon,
  column-gutter: 2em
))

== Pose Graph as Springs
#let show-ls-eq = place(
  bottom + center,
  $
    limits("minimize")_({X_1, ..., X_n}) quad &sum_(i, j) lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)^T 
    C_(i j)^(-1) 
    lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)
  $
)
#let show-ls-eq-cancel = place(
  bottom + center,
  $
    cancel(limits("minimize")_({X_1, ..., X_n}) quad &sum_(i, j) lr((macron(D)_(i j) - (X_i - X_j)), size:#120%)^T 
    C_(i j)^(-1) 
    lr((macron(D)_(i j) - (X_i - X_j)), size:#120%))
  $
)

// Approach

// This is what I spent my first couple weeks learning about. Reading papers. Lots of statistics things.

#align(center)[#image("aux/springs.png", height: 55%)]

// Hardest part is setting covariances
#pause

#show-ls-eq
---


#grid(
  image("aux/springs.png"),
  [
    #align(center)[Ways to Set Spring Elasticities (covariances)]
    #set text(size: 24pt)

    - Constant elasticity // this works pretty well, and even to the present it's what we're using
    - Model elasticity using pairwise features \
      $(i, j) -> C_(i j)^(-1)$ // not so good
  ],
  columns: (35%, 65%),
  rows: (60%),
  align: (right + horizon, left + horizon),
  column-gutter: 1em
)

#show-ls-eq

== Rooting out Bad Pairwise Registrations
#v(1em)
#grid(
  [
    #image("aux/error_z_all.png", height: 65%)
    #place(center + top, dx: -14pt, dy: -8pt, text(size: 18pt)[Comparing pairwise and global registrations])
    #place(left + top, dx: -1%, dy: 6%, rect(fill: white, height: 200pt))
    #place(left + bottom, dx: -1%, dy: 0%, rect(fill: white, width: 250pt, height: 40pt))
    #place(left + top, dx: 94%, dy: 6%, rect(fill: white, height: 200pt))
    #place(right + horizon, dx: 65pt, dy: -10pt, rotate(90deg, text(weight: "medium", size: 18pt)[Z axis difference (m)]))
  ],
  [
    - After optimization, some springs (pairwise registrations) are stretched
    - Lots of redundancy in the graph reveals poor pairwise registrations
    - Weight those springs less in optimization step or remove them entirely
  ],
  columns: (50%, 50%),
  align: (center + horizon, left + horizon),
  column-gutter: 1em,
  inset: (x: 1em)
)

== Lu-Milios Implementation
#let lawrence-reg-pres = {
  set text(size: 12pt)
  link("https://docs.google.com/presentation/d/1ylhLGAtZd3n0Wg0YLUSWutFb2xv_mUaj/edit?usp=sharing&ouid=117651070160453801114&rtpof=true&sd=true")[Jacob Lawrence's presentation on July 18]
}
#block()[
  #set list(spacing: 32pt)
  - Implemented registration optimizer using the closed-form least squares pose graph solution described in Lu and Milios' 1997 paper
  #let bm(it) = math.bold(math.upright(it))
  $
    bm(X) = (bm(H)^T bm(C)^(-1) bm(H))^(-1) bm(H)^T bm(C)^(-1) macron(bm(D)),
    quad quad quad bm(C)_bm(X) = (bm(H)^T bm(C)^(-1) bm(H))^(-1)
  $
  #pause
  - Parameters:
    - Expected translational error of 1 meter, 2 mrad \
      (constant covariance of $"diag"(1, 1, 1, 0.002^2, 0.002^2, 0.002^2)$)
    - Prune edges (pairwise registrations) whose optimized Mahalanobis distance has z-score higher than 1.5 among all edges
  #pause
  - Note: Improper to perform linear least squares on Euler angles, but works alright since angles are very small (no more than a few mrad)
]
== Comparing Old Optimizer with Lu-Milios
#align(center)[*Optimization Time (Barrett Park)*]
#place(center + horizon, block()[
  #set text(weight: "medium")
  #grid(
    [_Old ncc_nxn Optimizer_],
    [_Lu-Milios Optimizer_],
    text(size: 32pt)[2m 54s], 
    [
      #text(size: 32pt)[0m 3s]
      
      #text(gray, size: 16pt)[(58 times faster)]
    ],
    align: center + top,
    columns: (50%, 50%),
    row-gutter: 20pt,
    inset: 8pt
  )
])

#place(bottom + center, text(gray, size: 16pt)[See _References_ for link to old optimizer])

---
#align(center)[*Optimized Translation Plots (Barrett Park)*]
#v(-12pt)
#block()[
  #set text(weight: "medium")
  #grid(
    [_Old ncc_nxn Optimizer_],
    [_Lu-Milios Optimizer_],
    image("aux/registrations_oldopt.png"), image("aux/registrations_lumopt.png"),
    align: center + horizon,
    columns: (50%, 50%),
    rows: (10%, 72%)
  )
]

---
#align(center)[
  *Profile Analysis (Barrett Park, gazebo)* \
  #text(gray, weight: "medium", size: 18pt)[(only scans ending in `scan00010`)]
]
#image("aux/gazebo_target.png", height: 70%)
---
#align(center)[
  *Profile Analysis (Barrett Park, gazebo)* \
  #text(gray, weight: "medium", size: 18pt)[(only scans ending in `scan00010`)]
]
#v(-18pt)
#block()[
  #set text(weight: "medium")
  #grid(
    [_Old ncc_nxn Optimizer_],
    [_Lu-Milios Optimizer_],
    image("aux/old_gazebo.png", width: 95%), image("aux/lum_gazebo.png"),
    align: center + horizon,
    columns: (50%, 50%),
    rows: (10%, 65%)
  )
]
#place(center + bottom, dy: -20pt)[
  #text(gray, weight: "medium", size: 18pt)[(notice ghosting at upper left in both images)]
]
#place(left + bottom, dx: 168pt, dy: -55pt)[1 m]
#place(left + bottom, dx: 602pt, dy: -55pt)[1 m]
#place(left + bottom, dx: -20pt, dy: -136pt)[#rotate(-90deg)[1 m]]

---
#align(center)[
  *Profile Analysis (Barrett Park, building on northeast)* \
  #text(gray, weight: "medium", size: 18pt)[(only scans ending in `scan00010`)]
]
#image("aux/ghost_target.png", height: 70%)
---
#align(center)[
  *Profile Analysis (Barrett Park, building on northeast)* \
  #text(gray, weight: "medium", size: 18pt)[(only scans ending in `scan00010`)]
]
#v(-18pt)
#block()[
  #set text(weight: "medium")
  #grid(
    [_Old ncc_nxn Optimizer_],
    [_Lu-Milios Optimizer_],
    image("aux/old_ghost.png", width: 95%), image("aux/lum_ghost.png"),
    align: center + horizon,
    columns: (50%, 50%),
    rows: (10%, 65%)
  )
]
#place(center + bottom, dy: -20pt)[
  #text(gray, weight: "medium", size: 18pt)[(notice ghosting at upper left in both images)]
]
#place(left + bottom, dx: 112pt, dy: -27pt)[5 m]
#place(left + bottom, dx: 642pt, dy: -27pt)[5 m]
#place(left + bottom, dx: -20pt, dy: -160pt)[#rotate(-90deg)[2 m]]


== Ongoing and Future Work
// Problem is, angles are not linear and euclidean and friendly.
#show-ls-eq

#pause #place(center + horizon, grid(
  [
    #set text(size: 45pt)
    #place(center + horizon, dx: 110pt, dy: 100pt, emoji.checkmark.box)
    
    #image("aux/3d_axes.png", height: 60%)
  ],
  [
    #set text(size: 45pt)
    #image("aux/euler_rot.png", height: 50%)

  #place(center + horizon, dx: 110pt, dy: 100pt, emoji.crossmark)
  ],
  columns: (50%, 50%),
  align: center + horizon
))
#meanwhile $
X_i = vec(x_i, y_i, z_i, theta_i, phi.alt_i, psi_i) in RR^6
$

---
- Use non-linear least squares optimization to better handle orientation
- [#h(1em) lie algebra graph results #h(1em)]
- Be smarter in choosing pairwise registration covariance (uncertainty)
  - Automatically determine covariance using properties of the sensor or the data
  - Use pairwise registration features to determine covariance

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
#focus-slide()[Modeling the Laser Illumination Spot]
== Laser Illumination Spot

// Story behind spot modeling. Tracking and modeling the laser spot during scanning. Useful to analyze reflectivity. If we can track the spot, we can track how much light we probed a certain area with and get a good reflectivity estimate. Can be used for validation of proper alignment. Emphasize it was an exploration. Success! Could be useful for a few things. Good for QC, refine tx rx alignment. Lots of auto QC possibilities. A new way to look at the data. 
/*
- Ask how people think it might be useful for QC.
  - Pixel map is useful. Track pixels that are bugging out. 
  - Non-invasive. Can be done during flight operations. Doesn't require a certain scan pattern. 
  - Measure spot size. 
  - Track beam divergence.
*/

#place(horizon + center, dy: 6%, image("aux/spot.png", height: 95%))
// ---
// #align(center)[
//   #set text(size: 18pt)
//   Analyzing `20230627_095732_cuchillo1_scan00091.bpf`
// ]
// #place(horizon + center, dy: 7%, image("aux/scan91_z.png", height: 80%))
== Spot is Approximately Gaussian
#place(horizon + center, dy: 6%, dx: 0%, image("aux/avg_hitmap.png", height: 95%))
#align(left)[
  #set text(size: 22pt)
  Total *photon detections per pixel* during \
`20230627_095732_cuchillo1_scan00091.bpf`
]
#place(center + bottom, dx: -38pt, image("aux/normal.png", height: 25%))

== Cannot Assume the Spot Stays Still
#place(center + horizon, link("aux/hitmap_moving_average_window_100_slow.mp4", image("aux/hitmap-thumbnail.png", height:50%)))


== Cannot Use Sample Mean and Covariance
#place(left + horizon, image("aux/all_samples_boxed_raw.svg"))
#place(right + top, block(width: 40%)[
  #v(60pt)
  #set align(left)
  - 100 random Gaussian samples representing photons, not all of which are in-frame
  - Ring represents 1 standard deviation
  - We only see the samples within the frame
])
== Cannot Use Sample Mean and Covariance
#place(left + horizon, image("aux/all_samples_boxed.svg"))
#place(right + top, block(width: 40%)[
  #v(60pt)
  #set align(left)
  - 100 random Gaussian samples representing photons, not all of which are in-frame
  - Ring represents 1 standard deviation
  - We only see the samples within the frame
  - Fitting Gaussian with sample mean and covariance doesn't work
])

== Approach
#block()[
  // #set par(leading: 8pt)
  // #set list(spacing: 16pt)
  Fit a new Gaussian to each 100-frame pixel hitmap average (no filtering) with `pygmmis` #v(-0.6em)
  #par[]
  #set text(size: 24pt)
  - Written by Princeton astronomers to model luminosity of galaxies from truncated camera data (like ours)
  - Gaussian Mixture Models (GMMs) that can handle occluded data
  - Under the hood, uses Expectation Maximization (standard for GMMs), but also generates mock samples to handle occluded regions
]


== Successful Fit
#place(
  center + horizon, 
  link(
    "aux/spot_movement_window_100_gaussians_1_new_gmmis_1_in_1_slow.mp4", 
    {
      show link: it => it.default()
      place(center + horizon, image("aux/fitted-thumbnail.png", height:50%))
    }
  )
)

== Potential Applications
- Automatic quality control---non-invasive way to check alignment in-flight without a particular scan pattern
- Generate better pointwise reflectivity estimates
- Track pixels exhibiting unusual behavior in real time

== Future Work
- Continue investigating faster alternatives, using `pygmmis` as ground truth

  - Blur pixel heatmap to quickly track spot center without having to recalculate covariance

  - Fit to some subset of the data---random subset works surprisingly well

- Test on more scans

- Use to create an improved reflectivity estimate
  

== References
#block()[
  #set text(size: 18pt)
  #set list(spacing: 12pt)
  #set par(leading: 8pt)
  #grid(
    [
      *Processing Performance Report*
    ],
    [
      - #link("https://bitbucket.org/3deo/processing-performance/src/master/")[processing-performance (master) on Bitbucket]
      - #link("https://bitbucket.org/3deo/acadia/src/master/")[acadia (master) on Bitbucket] #text(gray, size: 12pt)[Apptainers in apptainer_creation and slurm bricks in processing_workflow]
      - #link("https://bitbucket.org/3deo/python_3deo/src/master/fileIO/readGSOF.py")[python_3deo/fileIO/readGSOF.py] #text(gray, size: 12pt)[Used to collect certain scanning information]
    ],
    [
      *Pose Graphs for Registration*
    ], 
    [
      - #link("https://bitbucket.org/3deo/zreg_ncc/src/master/python/")[zreg_ncc/python (master) on Bitbucket] #text(gray, size: 12pt)[see lu_milios.py for my Lu-Milios implementation, pose_graph.py for Lie algebra implementation in progress]
      - #link("references/registration presentation.pdf")[Presentation I gave on pose graph registration]
      - #link("references/registration presentation bonus.pdf")[Ideas related to the above presentation]
      - #link("https://robotics.caltech.edu/~jerma/research_papers/scan_matching_papers/milios_globally_consistent.pdf")[Lu and Milios paper] #text(gray, size: 12pt)["Globally Consistent Range Scan Alignment for Environment Mapping", April 1997. Introduces these ideas in the context of robotics]
      - #link("https://robotik.informatik.uni-wuerzburg.de/telematics/download/3dpvt2008.pdf")[Borrmann et al. paper] #text(gray, size: 12pt)["The Efficient Extension of Globally Consistent Scan Matching to 6 DoF", June 2008. Extends concepts in the above paper to 3D. We aren't using this paper's new ideas, but it helped me understand what was going on better]
      - #link("https://bitbucket.org/3deo/zreg_ncc/commits/2b6d0d4d201a815ffae8883256b333029eb7dc45#comment-17902146")[Old optimizer] #text(gray, size: 12pt)[Replaced by Lu-Milios in zreg_ncc commit 2b6d0d4 on July 18th] <old-opt>
    ],
    [
      *Modeling the Laser Illumination Spot*
    ],
    [
      - #link("references/illumination_spot_modeling.pdf")[Write-up] #text(gray, size: 12pt)[Describes background and my work thus far on this]
    ],
    columns: (40%, auto),
    align: (left + top, left + horizon),
    column-gutter: 1em,
    row-gutter: 1.5em,
    inset: .1em
  )
]
