// PoVRay 3.7 Scene File " ... .pov"
// Categorization.
// Exemple in 3D.
// author:  ...
// date:    ...
//------------------------------------------------------------------------
#version 3.7;
global_settings{ assumed_gamma 1.0 }
#default{ finish{ ambient 0.1 diffuse 0.9 }} 
//------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"
#include "transforms.inc"
//------------------------------------------------------------------------ right handed Coordinate system z up 
#declare Camera_0 = camera {/*ultra_wide_angle*/ angle 55  // front view from x+
                            sky z
                            location  <10.0 , 0.0 , 1.0>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_1 = camera {/*ultra_wide_angle*/ angle 14  // diagonal view
                            sky z
                            right    -x*image_width/image_height
                            location  <20.0,-20.0, 12.0 >
                            look_at   <0.0 , 0 , 1.2> }
#declare Camera_2 = camera {/*ultra_wide_angle*/ angle 55  //right side view from y-
                            sky z
                            location  <0.0 ,-10.0 , 1.0>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_3 = camera {/*ultra_wide_angle*/ angle 65   // top view from z- (x right y up )
                            sky z 
                            location  < 0,-0.001, 10>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_4 = camera {/*ultra_wide_angle*/ angle 25  // diagonal view
                            sky z
                            right    -x*image_width/image_height
                            location  <42.0,-42.0, 21.0 >
                            look_at   <2 , 2 , 3> }
camera{Camera_4} // 4
//------------------------------------------------------------------------
// sun -------------------------------------------------------------------
light_source{<000,000, 2500> color White}
// sky -------------------------------------------------------------------
sky_sphere{ pigment{ gradient <0,0,1>
                     color_map{ [0   color rgb<1,1,1>         ]//White
                                [0.2 color rgb<0.20,0.30,0.56>*0.9]//~Navy
                                [0.8 color rgb<0.20,0.30,0.56>*0.9]//~Navy
                                [1.0 color rgb<1,1,1>         ]//White
                              }
                     scale 2 }
           } // end of sky_sphere 
//------------------------------------------------------------------------

//------------------------------ the Axes --------------------------------
//------------------------------------------------------------------------
#macro Axis_( AxisLen, Dark_Texture,Light_Texture) 
 union{
    cylinder { <0,0,-AxisLen>,<0,0,AxisLen>,0.05
               texture{checker texture{Dark_Texture } 
                               texture{Light_Texture}           
                       translate<0.1,0,0.1>}
             }
    cone{<0,0,0>,0.2,<0,0,0.7>,0 translate<0,0, AxisLen> 
          texture{Dark_Texture}
         }
     } // end of union                   
#end // of macro "Axis()"
//------------------------------------------------------------------------
#macro AxisXYZ( AxisLenX, AxisLenY, AxisLenZ, Tex_Dark, Tex_Light)
//--------------------- drawing of 3 Axes --------------------------------
union{
#if (AxisLenX != 0)
 object { Axis_(AxisLenX, Tex_Dark, Tex_Light)   rotate< 0,90, 0>}// x-Axis
 text   { ttf "arial.ttf",  "x",  0.15,  0  rotate<90,0,0> texture{Tex_Dark} 
          rotate<-20,0,45> scale 0.75 translate <AxisLenX+0.05, 0.20, 0.30> no_shadow}
#end // of #if 
#if (AxisLenY != 0)
 object { Axis_(AxisLenY, Tex_Dark, Tex_Light)   rotate< 0,0,  0>}// y-Axis
 text   { ttf "arial.ttf",  "y",  0.15,  0  rotate<90,0, 0> texture{Tex_Dark}    
          rotate<-10,0,45> scale 0.75 translate <-0.20,AxisLenY+0.30, 0.30>  no_shadow}
#end // of #if 
#if (AxisLenZ != 0)
 object { Axis_(AxisLenZ, Tex_Dark, Tex_Light)   rotate<-90,0,  0>}// z-Axis
 text   { ttf "arial.ttf",  "z",  0.15,  0  rotate<90,0,0> texture{Tex_Dark}
          rotate<-10, 0,0> scale 0.75 translate <-0.50,0.0,AxisLenZ-0.50> rotate<0, 0,45> no_shadow}
#end // of #if 
} // end of union
#end// of macro "AxisXYZ( ... )"
//------------------------------------------------------------------------

#declare Texture_A_Dark  = texture {
                               pigment{ color rgb<1,0.40,0> }
                               finish { phong 1}
                             }
#declare Texture_A_Light = texture { 
                               pigment{ color rgb<1,1,1>}
                               finish { phong 1}
                             }

object{ AxisXYZ( 10.00, 10.00, 10.00, Texture_A_Dark, Texture_A_Light)}
//-------------------------------------------------- end of coordinate axes


// ground -----------------------------------------------------------------
//---------------------------------<<< settings of squared plane dimensions
#declare RasterScale = 1.0;
#declare RasterHalfLine  = 0.035;  
#declare RasterHalfLineZ = 0.035; 
//-------------------------------------------------------------------------
#macro Raster(RScale, HLine) 
       pigment{ gradient y scale RScale
                color_map{[0.000   color rgbt<1,1,1,0>*0.6]
                          [0+HLine color rgbt<1,1,1,0>*0.6]
                          [0+HLine color rgbt<1,1,1,1>]
                          [1-HLine color rgbt<1,1,1,1>]
                          [1-HLine color rgbt<1,1,1,0>*0.6]
                          [1.000   color rgbt<1,1,1,0>*0.6]} }
 #end// of Raster(RScale, HLine)-macro    
//-------------------------------------------------------------------------
    

plane { <0,0,1>, 0    // plane with layered textures
        texture { pigment{color White*1.1}
                  finish {ambient 0.45 diffuse 0.85}}
        texture { Raster(RasterScale,RasterHalfLine ) rotate<0,0,0> }
        texture { Raster(RasterScale,RasterHalfLineZ) rotate<0,0,90>}
        rotate<0,0,0>
      }
//------------------------------------------------ end of squared plane XZ

//--------------------------------------------------------------------------
//---------------------------- objects in scene ----------------------------
//--------------------------------------------------------------------------

#declare Categ1 = sphere { <0,0,0>, 0.5 

         texture { pigment{ color Red } // rgb< 1, 0.0, 0.0>}
                   finish { phong 1 reflection 0.10 metallic 0.20}
                 } // end of texture 

          scale<1,1,1>  rotate<0,0,0>  translate<0,0,0>  
       }  // end of sphere ----------------------------------- 


#declare Categ2 = box { <-1.00, 0.00, -1.00>,< 1.00, 2.00, 1.00>   

      texture { pigment{ color rgb<0.00, 0.00, 1.00>}  
                finish { phong 1 reflection{ 0.05 metallic 0.20} } 
              } // end of texture

      scale <0.5,0.5,0.5> rotate<0,0,0> translate<0,0,0> 
    } // end of box --------------------------------------

#declare Categ3 = union {cone { <0,0,0>,0.5,<0,.50,0>,0 

     } // end of cone1 -------------------------------------
 
 cone{<0,0,0>,0.5,<0,-.50,0>,0}     // end of cone2 -------------------------------------
   texture { pigment{ color rgb<1,0.60,0.0>}
                 finish { phong 1 reflection{ 0.00 metallic 0.00} } 
               } // end of texture

       scale <1,1,1> rotate<90,0,0> translate<0,0,0>         
}


object {Categ1 translate<14,-3,2>  }
object {Categ1 translate<13,-5,4>  }
object {Categ1 translate<15,-2,5>  }
object {Categ1 translate<13,-4,6>  }
object {Categ1 translate<12,-2,4>  }

object {Categ2 translate<4,0,1>  }
object {Categ2 translate<2,0,3>  }
object {Categ2 translate<4,2,1>  }
object {Categ2 translate<6,0,2>  }
object {Categ2 translate<3,1,4>  }

object {Categ3 translate<1,-9,2>  }
object {Categ3 translate<3,-8,3>  }
object {Categ3 translate<3,-5,3>  }
object {Categ3 translate<4,-7,5>  }
object {Categ3 translate<5,-9,5>  }