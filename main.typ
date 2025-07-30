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


== Introduction
#align(center + horizon)[#block(width: 60%)[
  *A few goals to discuss.*
  #set align(left)
  #set par(leading: 8pt, spacing: 16pt)
  1. Infer global registrations from pairwise registrations
  
  2. Model laser spot illumination as a Gaussian from sensor data

  3. Generate a processing performance report

  #v(2em)
]]

== Global registration from pairwise registration

#pause
// Goal

// We can usually calculate how to move one scan to align with another (pairwise registration). How can we move $n$ scans to align with each other (global registration)?
We have ways to move one scan to align with another, with some uncertainty. How can we move $n$ scans to align with each other?

---
#let reg-slide(path) = {
  place(center + horizon, dy: 8%, image(path, height: 95%))
}
#reg-slide("aux/pairwise registration-2.png")
---
#reg-slide("aux/pairwise registration-3.png")
---
#reg-slide("aux/pairwise registration-4.png")
---
#reg-slide("aux/pairwise registration-5.png")
---
#reg-slide("aux/pairwise registration-6.png")
---
#reg-slide("aux/pairwise registration-7.png")
---
#reg-slide("aux/pairwise registration-8.png")
---

We have ways to move one scan to align with another, with some uncertainty. How can we move $n$ scans to align with each other?

#v(2em)

#align(center, grid(
  image("aux/graph-3-4.png", height: 40%),
  [
    #pause
    // $X_i = (x_i, y_i, z_i, theta_i, phi_i, psi_i) in RR^6$ is a scan position

    // $macron(D)_(i j): RR^6 arrow RR^6$ transforms points from scan $j$'s frame to scan $i$'s frame
    
    // #v(1em)

    Unfortunately, $macron(D)_13 != macron(D)_12 macron(D)_23.$
  ],
  columns: (30%, auto),
  align: left + horizon,
  column-gutter: 2em
))

---
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
Pose graph optimization.

// This is what I spent my first couple weeks learning about. Reading papers. Lots of statistics things.

#align(center)[#image("aux/springs.png", height: 55%)]

// Hardest part is setting covariances
#pause

#show-ls-eq
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

#show-ls-eq

---
// Problem is, angles are not linear and euclidean and friendly.
#show-ls-eq

#pause #place(center + horizon, grid(
  [
    #set text(size: 45pt)
    
    #image("aux/3d_axes.png", height: 60%)
  ],
  [
    #set text(size: 45pt)
    #image("aux/euler_rot.png", height: 50%)
  ],
  columns: (50%, 50%),
  align: center + horizon
))
#meanwhile $
X_i = vec(x_i, y_i, z_i, theta_i, phi_i, psi_i) in RR^6
$
---
#show-ls-eq

#place(center + horizon, grid(
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
$
X_i = vec(x_i, y_i, z_i, theta_i, phi.alt_i, psi_i) in RR^6
$

// ---
// #place(center + horizon, grid(
//   [
//     #set text(size: 45pt)
//     #place(center + horizon, dx: 110pt, dy: 100pt, emoji.checkmark.box)
    
//     #image("aux/3d_axes.png", height: 60%)
//   ],
//   [
//     #set text(size: 45pt)
//     #image("aux/euler_rot.png", height: 50%)

//   #place(center + horizon, dx: 110pt, dy: 100pt, emoji.crossmark)
//   ],
//   columns: (50%, 50%),
//   align: center + horizon
// ))
// $
// X_i = vec(x_i, y_i, z_i, theta_i, phi_i, psi_i) in RR^6
// $

// ---

// Pose graph optimization.


// #block()[
//   #set text(size: 16pt)
//   #grid(
//     image("aux/springs.png", height: 50%),
//     grid(
//       [$S E (3)$], text(gray)[space of transformation matrices. 6-dimensional],
//       arrow, [],
//       [$frak(s) frak(e) (3)$], text(gray)[associated Lie algebra. Perform optimization in this space],
//       arrow, [],
//       [$S E (3)$], [],
//       columns: (20%, auto),
//       align: (center + horizon, left + horizon),
//       column-gutter: 1em,
//       row-gutter: 1em,
//       inset: (x: 1em)
//     ),
//     columns: (40%, 60%),
//     align: center + horizon
//   )
// ]


// #image("image.png", height: 25%)



---

Pruning and weighting.

#grid(
  [
    #image("aux/error_z_all.png", height: 65%)
    #place(center + top, dx: -14pt, dy: -2pt, text(size: 14pt)[Comparing pairwise and global registrations])
  ],
  [
    - After optimization, some springs (pairwise registrations) are stretched
    - Lots of redundancy in the graph reveals poor pairwise registrations
    - Weight those springs less in optimization step or remove them
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
    #pause
    - #link("aux/spot_movement_window_100_gaussians_1.mp4")[Model with Gaussian Mixture Model (1 component)]
    // GMMis works great
    #pause
    - #link("aux/spot_movement_window_100_gaussians_1_new_gmmis_1_in_1.mp4")[Model with GMMis]
    #pause
    - #link("aux/spot_movement_window_100_gaussians_1_gmmis_1_in_100.mp4")[Model with GMMis, keep only 1% of detections] // Useful for integrating in the processing chain. 
  ]
  #meanwhile #hr

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

    A consise, readable .pdf report summarizing key insights from processing.

    #set text(size: 18pt)
    Located in #text(gray)[`<acadia-output-directory>/`]`qc/processing_report` after processing is complete
  ],
  image("aux/thumbnail-report.png", height: 100%),
  image("aux/thumbnail-report-mapping.png", height: 100%),
  columns: (60%, 10%, 10%),
  align: horizon + left,
  gutter: 1em
))
---
#image("aux/vulcan_mapping_top.png", height: 80%)
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
  Processing directory \
  #text(gray, size: 14pt)[say, `albert:/shares/processed/cuchillo/flightData/FlatCreek`]
  
  #arrow 
  
  .json of filepaths and statistics \
  #text(gray, size: 14pt)[to be used in report]
  
  #arrow
  
  #LaTeX report
  #arrow

  .pdf report
]

== References
#block()[
  #set text(size: 18pt)
  #grid(
    [
      *Global from pairwise registration*
    ], 
    [
      - #link("https://bitbucket.org/3deo/zreg_ncc/src/master/python/")[zreg_ncc/python (master) on Bitbucket]
      - #link("references/registration presentation.pdf")[Presentation I gave on pose graph registration]
      - #link("references/registration presentation bonus.pdf")[Ideas related to the above presentation]
      - #link("https://robotics.caltech.edu/~jerma/research_papers/scan_matching_papers/milios_globally_consistent.pdf")[Lu and Milios paper] #text(gray, size: 12pt)["Globally Consistent Range Scan Alignment for Environment Mapping", April 1997. Introduces these ideas in the context of robotics]
      - #link("https://robotik.informatik.uni-wuerzburg.de/telematics/download/3dpvt2008.pdf")[Borrmann et al. paper] #text(gray, size: 12pt)["The Efficient Extension of Globally Consistent Scan Matching to 6 DoF", June 2008. Extends concepts in the above paper to 3D. We aren't using this paper's ideas, but it helped me understand what was going on better]
    ],
    [
      *Laser spot modeling*
    ],
    [
      - #link("references/illumination_spot_modeling.pdf")[Write-up] #text(gray, size: 12pt)[Describes background and my work thus far on this]
      - I have the git repo, but the code is unfinished, so I haven't pushed to Bitbucket. Should I push?
    ],
    [
      *Processing performance report*
    ],
    [
      - #link("https://bitbucket.org/3deo/processing-performance/src/master/")[processing-performance (master) on Bitbucket]
      - #link("https://bitbucket.org/3deo/acadia/src/master/")[acadia (master) on Bitbucket] #text(gray, size: 12pt)[Apptainers in apptainer_creation and slurm bricks in processing_workflow]
      - #link("https://bitbucket.org/3deo/python_3deo/src/master/fileIO/readGSOF.py")[python_3deo/fileIO/readGSOF.py] #text(gray, size: 12pt)[Used to collect certain scanning information]
    ],
    columns: (40%, auto),
    align: (left + top, left + horizon),
    column-gutter: 1em,
    row-gutter: 1.5em,
    inset: .1em
  )
]
