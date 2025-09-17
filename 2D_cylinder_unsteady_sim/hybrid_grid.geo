mesh_size = 0.1;
D = 1;
pi = 3.14;

//========================= POINTS ========================
// Usage : Point(n) = {x, y, z, mesh_size};

Point(1) = {0, 0, 0, mesh_size};
Point(2) = {0, 0.5*D, 0, 0.25*mesh_size};           // Reducing the mesh size at Points 2 and 3 to refine the grids on the cylinder surface
Point(3) = {0, -0.5*D, 0, 0.25*mesh_size};
Point(4) = {-20*D, -20*D, 0, 15*mesh_size};
Point(5) = {-20*D, 20*D, 0, 15*mesh_size};
Point(6) = {50*D, -20*D, 0, 15*mesh_size};
Point(7) = {50*D, 20*D, 0, 15*mesh_size};

//========================= CURVE ========================
// Usage : Line(n) = {Point(4), Point(6)};

Line(1) = {4, 6};
Line(2) = {6, 7};
Line(3) = {7, 5};
Line(4) = {5, 4};

// Usage : Circle(n) = {Point(3), Point(1), Point(2)};

Circle(5) = {2, 1, 3};
Circle(6) = {3, 1, 2};

//========================= CURVE LOOP ========================
// Usage : Curve Loop(n) = {Line(4), Line(1), ...} or {Circle(15), Circle(16)};

Curve Loop(1) = {3, 4, 1, 2};     // Define a loop consisting of lines, circles, or both
Curve Loop(2) = {5, 6};

//========================= SURFACE ========================
// Usage : Plane Surface(n) = {Curve Loop(1), Curve Loop(2)};
// Usage : Surface(n) = {Curve Loop(7)}

Plane Surface(1) = {1, 2};     // Define the domain's surfaces




//========================= SIZE FIELDS ========================

// Boundary layer meshing
Field[1] = BoundaryLayer;                    // Define a BL mesh region
Field[1].CurvesList = {5, 6};                // Select the curves where you want to place the boundary layer field (here cylinder curves)
Field[1].hwall_n = 0.0008;                   // First-layer thickness (Δy1)
Field[1].NbLayers = 40;                      // Number of layers
Field[1].ratio = 1.1;                        // Growth ratio
Field[1].thickness = 0.12;                   // Boundary-layer thickness (optional)
Field[1].IntersectMetrics = 1;               // Helps intersections/corners
Field[1].Quads = 1;                          // Generate quad BL cells
BoundaryLayer Field = 1;                     // Enable the BL field directly (essential)



// 1st refinement region
// Box mesh refinement region around the geometry
Field[2] = Box;                              // Define a rectangular mesh refinement region
Field[2].VIn = 0.3;
Field[2].XMax = 50;
Field[2].XMin = 0;
Field[2].YMax = 6;
Field[2].YMin = -6;
Background Field = 2;

// Cylindrical mesh refinement region (box's outer left)
Field[3] = Cylinder;                         // Define a cylindrical mesh refinement region
Field[3].Radius = 6;                         // Radius of the cylinder refinement region
Field[3].VIn = 0.3;                          // Target mesh size inside the cylinder region
Field[3].XCenter = 0;                        // X-coordinate of the cylinder center
Field[3].YCenter = 0;                        // Y-coordinate of the cylinder center
Background Field = 3;



// 2nd refinement region
// Box mesh refinement region around the geometry
Field[4] = Box;                              // Define a rectangular mesh refinement region
Field[4].VIn = 0.1;
Field[4].XMax = 50;
Field[4].XMin = 0;
Field[4].YMax = 2.5;
Field[4].YMin = -2.5;
Background Field = 4;

// Cylindrical mesh refinement region (box's outer left)
Field[5] = Cylinder;                         // Define a cylindrical mesh refinement region
Field[5].Radius = 2.5;                       // Radius of the cylinder refinement region
Field[5].VIn = 0.1;                          // Target mesh size inside the cylinder region
Field[5].XCenter = 0;                        // X-coordinate of the cylinder center
Field[5].YCenter = 0;                        // Y-coordinate of the cylinder center
Background Field = 5;



// 3rd refinement region
// Box mesh refinement region around the geometry
Field[6] = Box;                              // Define a rectangular mesh refinement region
Field[6].VIn = 0.033;
Field[6].XMax = 5;
Field[6].XMin = 0;
Field[6].YMax = 1;
Field[6].YMin = -1;
Background Field = 6;

// Cylindrical mesh refinement region (box's outer left)
Field[7] = Cylinder;                         // Define a cylindrical mesh refinement region
Field[7].Radius = 1;                         // Radius of the cylinder refinement region
Field[7].VIn = 0.033;                        // Target mesh size inside the cylinder region
Field[7].XCenter = 0;                        // X-coordinate of the cylinder center
Field[7].YCenter = 0;                        // Y-coordinate of the cylinder center
Background Field = 7;

// Cylindrical mesh refinement region (box's outer right)
Field[8] = Cylinder;                         // Define a cylindrical mesh refinement region
Field[8].Radius = 1;                         // Radius of the cylinder refinement region
Field[8].VIn = 0.033;                        // Target mesh size inside the cylinder region
Field[8].XCenter = 5;                        // X-coordinate of the cylinder center
Field[8].YCenter = 0;                        // Y-coordinate of the cylinder center
Background Field = 8;



// Combine all refinement regions
Field[9] = Min;
Field[9].FieldsList = {2, 3, 4, 5, 6, 7, 8};
Background Field = 9;



//========================= PHYSICAL TAGS ========================

Physical Curve("inlet", 1) = {4};
Physical Curve("outlet", 2) = {2};
Physical Curve("wall", 3) = {3, 1};
Physical Curve("cylinder", 4) = {5, 6};

