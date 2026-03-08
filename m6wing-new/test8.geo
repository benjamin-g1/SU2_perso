SetFactory("OpenCASCADE");

// Import external geometry
Merge "domain_scaled.step";           // always put the domain in first
Merge "wing_test_scaled.step";

// Clean geometry and remove duplicate entities
Coherence;

// Wing parameters
c_root = 0.2053;
b_span = 0.3048;

// Main-wing & Tip parameters
n_front_section = 7;
n_mid_section = 56;
n_end_section = 14;
n_back_section = 4;
n_wing_span = 350;

n_front_section_arc = 7;
n_mid_section_arc = 10;
n_end_section_arc = 4;
n_back_section_arc = 4;

// Outer-domain parameters
n_outer_domain = 15;

// Box parameters
n_box_horizontal = 112;
n_box_vertical = 28;


//========================= POINTS ========================
// Usage : Point(n) = {x, z, y};

// Refinement region coordinate
Point(25) = {-0.15*c_root, 0, 0.15*c_root};
Point(26) = {-0.15*c_root, 0, -0.15*c_root};
Point(27) = {1.4*c_root, 0, 0.15*c_root};
Point(28) = {1.4*c_root, 0, -0.15*c_root};

Point(29) = {0.8*c_root, 1.1*b_span, 0.15*c_root};
Point(30) = {0.8*c_root, 1.1*b_span, -0.15*c_root};
Point(31) = {1.8*c_root, 1.1*b_span, 0.15*c_root};
Point(32) = {1.8*c_root, 1.1*b_span, -0.15*c_root};

//========================= CURVE ========================
// Usage : Line(47) = {Point(25), Point(26)};

Line(47) = {25, 26};
Line(48) = {25, 27};
Line(49) = {27, 28};
Line(50) = {28, 26};

Line(51) = {30, 29};
Line(52) = {29, 31};
Line(53) = {31, 32};
Line(54) = {32, 30};

Line(55) = {25, 29};
Line(56) = {27, 31};
Line(57) = {28, 32};
Line(58) = {26, 30};



//========================= TRANSFINITE CURVE WING ========================
// Usage : Transfinite Curve {Line(3), Line(6), Line(10), ...} = number_of_points_wanted Using Progession 1;

// Transfinite Curve with "Progression": nodes cluster toward one end only
// Progression direction goes from the first point to the second point of the curve
// r = 1 >> uniform spacing
// r > 1 >> spacing increases from start to end
// r < 1 >> spacing decreases from start to end (clustering toward end)



// Transfinite setting applied to Main-wing & Tip

Transfinite Curve {8, 6, 28, 10, 25, 13, 22, 16, 19} = n_wing_span Using Progression 1;

Transfinite Curve {5, 30, 7, 31, 33} = n_front_section Using Progression 1;
Transfinite Curve {9, 27, 11, 29, 37, 12, 24, 14, 26, 40} = n_mid_section Using Progression 1;
Transfinite Curve {15, 21, 17, 23, 43} = n_end_section Using Progression 1;
Transfinite Curve {18, 20} = n_back_section Using Progression 1;

Transfinite Curve {34, 36} = n_front_section_arc Using Progression 1;
Transfinite Curve {38, 39} = n_mid_section_arc Using Progression 1;
Transfinite Curve {41, 42} = n_end_section_arc Using Progression 1;
Transfinite Curve {44, 45} = n_back_section_arc Using Progression 1;


// Transfinite setting applied to Outer-domain

Transfinite Curve {2, 4} = n_outer_domain Using Progression 1;


// Transfinite setting applied to Box

Transfinite Curve {47, 49, 51, 53} = n_box_vertical Using Progression 1;
Transfinite Curve {48, 50, 55, 58, 57, 56, 54, 52} = n_box_horizontal Using Progression 1;




//========================= CURVE LOOP/SURFACE ========================

// Surface setting applied to Box

Curve Loop(2) = {47, 58, 51, -55};
Plane Surface(20) = {2};
Curve Loop(3) = {51, 52, 53, 54};
Plane Surface(21) = {3};
Curve Loop(4) = {56, 53, -57, -49};
Plane Surface(22) = {4};
Curve Loop(5) = {58, -54, -57, 50};
Plane Surface(23) = {5};
Curve Loop(6) = {55, 52, -56, -48};
Plane Surface(24) = {6};

Curve Loop(7) = {47, -50, -49, -48};
Curve Loop(8) = {5, 9, 12, 15, 18, -21, -24, -27, -30};
Plane Surface(25) = {7, 8};

// Surface between Box and Outer-domain

Curve Loop(9) = {4, -2};
Curve Loop(10) = {47, -50, -49, -48};
Plane Surface(26) = {9, 10};



//========================= SURFACE LOOP ========================
// Usage : Surface Loop(n) = {Plane Surface(1), ..., Surface(8)}

// First surface loop between wing and box
Surface Loop(1) = {25, 10, 2, 3, 4, 5, 6, 7, 8, 9, 14, 13, 11, 12, 15, 16, 18, 17, 19, 20, 23, 21, 24, 22};      // Define a surface loop


// Second surface loop between box and outer-domain
Surface Loop(2) = {20, 23, 21, 24, 22, 26, 1};      // Define a surface loop



//========================= VOLUME ========================
// Usage : Volume(n) = {Surface Loop(1)}

Volume(1) = {1};   // Define a 3D volume enclosed by the given surfaces of the surface loop 1
Volume(2) = {2};



//========================= AUTOMATED MESH GENERATION ========================

Mesh 2;           // Generate surface mesh
Mesh 3;           // Generate volume mesh




//========================= FIELD & BOUNDARY DEFINITION ========================
// Usage : Physical Volume("Fluid", 20) = {Volume(1)};
// Usage : Physical Surface("Inlet", 21) = {Plane Surface(3)};

Physical Volume("fluid", 68) = {2, 1};

Physical Surface("geometry", 69) = {10, 2, 9, 3, 8, 4, 7, 5, 6, 11, 12, 13, 14, 15, 16, 17, 18, 19};
Physical Surface("symmetry", 70) = {27, 28};          // These surfaces are created when generating surface loops 1 and 2
Physical Surface("farfield", 71) = {1};
