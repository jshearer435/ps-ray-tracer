
class Vect  {
    [double] $x
    [double] $y
    [double] $z
    Vect ()  {
        $this.x = 0
        $this.y = 0
        $this.z = 0
    }
    Vect  ([double] $x, [double] $y, [double] $z)  {
        $this.x = $x
        $this.y = $y
        $this.z = $z
    }
    [double] getVectX()  {
        return $this.x
    }
    [double] getVectY()  {
        return $this.y
    }
    [double] getVectZ()  {
        return $this.z
    }
    [double] magnitude()  {
        return [double] [math]::Sqrt(($this.x*$this.x) + ($this.y*$this.y) + ($this.z*$this.z))
    }
    [Vect] normalize()  {
        $magnitude = [double] [math]::Sqrt(($this.x*$this.x) + ($this.y*$this.y) + ($this.z*$this.z))
        return [Vect]::new($this.x/$magnitude, $this.y/$magnitude, $this.z/$magnitude)  
    }
    [Vect] negative()  {
        return [Vect]::new(-$this.x, -$this.y, -$this.z)
    } 
    [double] dotproduct( [Vect] $V )  {
        return $this.x*$V.getVectX() + $this.y*$V.getVectY() + $this.z*$V.getVectZ()
    }
    [Vect] vectAdd ( [Vect] $V )  {
        return [Vect]::new($this.x + $V.getVectX(), $this.y + $V.getVectY(), $this.z + $V.getVectZ())
    }
    [Vect] vectMult( [double] $scaler )  {
        return [Vect]::new($this.x * $scaler, $this.y * $scaler, $this.z * $scaler)
    }
    [Vect] crossproduct ( [Vect] $V )  {
        return [Vect]::new( $this.y*$V.getVectZ() - $this.z*$V.getVectY(), $this.z*$V.getVectX() - $this.x*$V.getVectZ(), $this.x*$V.getVectY() - $this.y*$V.getVectX() )
    }
}

class Ray  {
    [Vect] $origin
    [Vect] $direction
    Ray ()  {
        $this.origin = [Vect]::new(0,0,0)
        $this.direction = [Vect]::new(1,0,0)
    }
    Ray ([Vect] $origin, [Vect] $direction)  {
        $this.origin = $origin
        $this.direction = $direction
    }
    [Vect] getRayOrigin()  {
        return $this.origin
    }
    [Vect] getRayDirection()  {
        return $this.direction
    }
}

class Camera  {
    [Vect] $CameraPosition
    [Vect] $CameraDirection
    [Vect] $CameraRight
    [Vect] $CameraDown
    Camera ()  {
        $this.CameraPosition = [Vect]::new(0,0,0)
        $this.CameraDirection = [Vect]::new(0,0,1)
        $this.CameraRight = [Vect]::new(0,0,0)
        $this.CameraDown = [Vect]::new(1,0,0)
    }
    Camera  ([Vect] $CameraPosition, [Vect] $CameraDirection, [Vect] $CameraRight, [Vect] $CameraDown)  {
        $this.CameraPosition = $CameraPosition
        $this.CameraDirection = $CameraDirection
        $this.CameraRight = $CameraRight
        $this.CameraDown = $CameraDown
    }
    [Vect] getCameraPosition()  {
        return $this.CameraPosition
    }
    [Vect] getCameraDirection()  {
        return $this.CameraDirection
    }
    [Vect] getCameraRight()  {
        return $this.CameraRight
    }
    [Vect] getCameraDown()  {
        return $this.CameraDown
    }
}

class Color  {
    [double] $r
    [double] $g
    [double] $b
    [double] $special
    Color ()  {
        $this.r = 0.5
        $this.g = 0.5
        $this.b = 0.5
        $this.special = 0
    }
    Color  ([double] $r, [double] $g, [double] $b, [double] $special)  {
        $this.r = $r
        $this.g = $g
        $this.b = $b
        $this.special = $special
    }
    [double] getColorR()  {
        return $this.r
    }
    [double] getColorG()  {
        return $this.g
    }
    [double] getColorB()  {
        return $this.b
    }
    [double] getColorspecial()  {
        return $this.special
    }
    [void] setColorRed( [double] $redValue )  {
        $this.r = $redValue
    }
    [void] setColorGreen( [double] $greenValue )  {
        $this.g = $greenValue 
    }
    [void] setColorBlue( [double] $blueValue )  {

        $this.b = $blueValue 
    }
    [void] setColorSpecial( [double] $specialValue )  {
        $this.special = $specialValue 
    }
    [double] brightness ()  {
        return ($this.r + $this.g + $this.b) / 3
    }
    [Color] colorScaler ( [double] $scaler )  {
        return [Color]::new($this.r * $scaler, $this.g * $scaler,$this.b * $scaler, $this.special)
    }
    [Color] colorAdd ( [Color] $color )  {
        return [Color]::new($this.r + $color.getColorR(), $this.g + $color.getColorG(),$this.b + $color.getColorB(), $this.special)
    }
    [Color] colorMultiply ( [Color] $color)  {
        [double] $red = $this.r * $color.r
        [double] $green = $this.g * $color.g
        [double] $blue = $this.b * $color.b
        [double] $spec = $this.special * $color.special
        return [Color]::new($red, $green, $blue, $spec)
    }
    [Color] colorAverage ( [Color] $color)  {
        return [Color]::new(($this.r + $color.getColorR) / 2, ($this.g + $color.getColorG) / 2, ($this.b + $color.getColorB) / 2, $this.special)
    }
    [Color] clip ( )  {
        [double] $all_light = $this.r + $this.g + $this.b 
        [double] $excess_light = $all_light - 3
        if ($excess_light -gt 0)  {
            $this.r = $this.r + $excess_light * ($this.r/$all_light)
            $this.g = $this.g + $excess_light * ($this.g/$all_light)
            $this.b = $this.b + $excess_light * ($this.b/$all_light)
            $this.special = $this.special + $excess_light * ($this.special/$all_light)
        }
        if ($this.r -gt 1)  {
            $this.r = 1    
        }
        if ($this.r -lt 0)  {
            $this.r = 0     
        }
        if ($this.g -gt 1)  {
            $this.g = 1     
        }
        if ($this.g -lt 0)  {
            $this.g = 0     
        }
        if ($this.b -gt 1)  {
            $this.b = 1     
        }
        if ($this.b -lt 0)  {
            $this.b = 0     
        }
        if ($this.special -gt 1)  {
            $this.special = 1     
        }
        if ($this.special -lt 0)  {
            $this.special = 0     
        }
    return [Color]::new($this.r, $this.g, $this.b, $this.special)
    }
}

class Light  {
    [Vect] $position
    [Color] $color
    Light ()  {
        $this.position = [Vect]::new(0,0,0)
        $this.color = [Color]::new(1,1,1, 0)
    }
    Light  ([Vect] $position, [Color] $color)  {
        $this.position = $position
        $this.color = $color
    }
    [Vect] getLightPosition()  {
        return $this.position
    }
    [Color] getLightColor()  {
        return $this.color
    }
}

class Object  {
    Object ()  {
    }
    [Color] getObjectColor()  {
        return [Color] (0, 0, 0, 0)
    } 
    [Color] getAlternateColor ()  {
        return [Color] (1, 1, 1, 0)
    } 
}

class Sphere : Object  {
    [Vect] $center
    [double] $radius
    [Color] $color
    Sphere ()  {
        $this.center = [Vect]::new(0,0,0)
        $this.radius = 1.0
        $this.color = [Color]::new(0.5,0.5,0.5, 0)
    }
    Sphere ([Vect] $center, [double] $radius, [Color] $color)  {
        $this.center = $center
        $this.radius = $radius
        $this.color = $color
    }
    [Vect] getSphereCenter()  {
        return $this.center
    }
    [Color] getSphereRadius()  {
        return $this.radius
    }
    [Color] getColor()  {
        return $this.color
    }
    [Vect] getNormalAt( [Vect] $point )  {
        # normal always points away from the origin of a shpere
        $normal_vector = $point.vectAdd($this.center.negative().normalize())
        return $normal_vector
    }
    [double] findIntersection([Ray] $ray)  {
        $ray_origin = $ray.getRayOrigin()
        $ray_origin_x = $ray_origin.getVectX()
        $ray_origin_y = $ray_origin.getVectY()
        $ray_origin_z = $ray_origin.getVectZ()
        $ray_direction = $ray.getRayDirection()
        $ray_direction_x = $ray_direction.getVectX()
        $ray_direction_y = $ray_direction.getVectY()
        $ray_direction_z = $ray_direction.getVectZ()
        $sphere_center = $this.center
        $sphere_center_x = $sphere_center.getVectX()
        $sphere_center_y = $sphere_center.getVectY()
        $sphere_center_z = $sphere_center.getVectZ()
        $a = 1.0  # normalized
        $b = (2 * ($ray_origin_x - $sphere_center_x) * $ray_direction_x) + (2 * ($ray_origin_y - $sphere_center_y) * $ray_direction_y) + (2 * ($ray_origin_z - $sphere_center_z) * $ray_direction_z)  
        $c = [math]::pow($ray_origin_x - $sphere_center_x, 2) + [math]::pow($ray_origin_y - $sphere_center_y, 2) + [math]::pow($ray_origin_z - $sphere_center_z, 2) - $this.radius*$this.radius
        $discriminant = $b * $b - 4 * $c
        if ( $discriminant -gt 0 )  {
        # the ray intersects the shpere
            # the first root
            $root_1 = ((-1*$b - [math]::sqrt($discriminant))/2) - .000001
            if ($root_1 -gt 0)  {
            # the first root is the smallest positive root
                return $root_1
            }
            else  {
                # the second root is the smallest positive root
                $root_2 = (([math]::sqrt($discriminant) - $b)/2) - .000001
                return $root_2
            }
        }
        else  {
            # the ray missed the sphere
            return -1
        }
    }
}

class Plane : Object  {
    [Vect] $normal
    [double] $distance
    [Color] $color
    Plane ()  {
        $this.normal = [Vect]::new(1,0,0)
        $this.distance = [double] 1.0
        $this.color = [Color]::new(0.5,0.5,0.5, 0)
    }
    Plane ([Vect] $normal, [double] $distance, [Color] $color)  {
        $this.normal = $normal
        $this.distance = $distance
        $this.color = $color
    }
    [Vect] getPlaneNormal()  {
        return $this.normal
    }
    [double] getPlaneDistance()  {
        return $this.distance
    }
    [Color] getColor()  {
        return $this.color
    }
    [Vect] getNormalAt( [Vect] $point )  {
        return [Vect] $this.normal
    }
    [double] findIntersection( [Ray] $ray )  {
        $ray_direction = $ray.getRayDirection()
        [double] $a = $ray_direction.dotproduct($this.normal)
        if ( $a -eq 0 )  {
            # ray paralell to plane
            return -1
        }
        else  {
            [double] $b = $this.normal.dotproduct($ray.getRayOrigin().vectAdd($this.normal.vectMult($this.getPlaneDistance()).negative()))
            return -1*$b/$a
        }
    }
}

function WinningObjectIndex ( $obj_array  )  {
    if ( $obj_array.count -eq 0 )  {
        return -1
    }
    elseif ( $obj_array.count -eq 1 )  {
        # if that intersection is greater than zero it is our index of minimum value
        if ( $obj_array[0] -gt 0 )  {
            return 0
        }
        else  {
            return -1
        }
    } 
    else  {
        # there is more than one intersection
        $max = 0.0
        for ( $i = 0; $i -lt $obj_array.count; $i++)  {
            if ( $max -lt $obj_array[$i] )  {
                $max = $obj_array[$i]
            }  
        }
        if ( $max -gt 0.0 )  {
            for ( $i = 0; $i -lt $obj_array.count; $i++)  {
                if ( $obj_array[$i] -gt 0.0 -and $obj_array[$i] -le $max )  {
                    $max = $obj_array[$i] 
                    $index_of_minimum_value = $i   
                }
            }
            return $index_of_minimum_value
        }
        else  {
            return -1
        }
    }
}

function getColorAt( $intersection_position, $intersection_direction, $scene_objects,[int] $index_of_winning_object, $light_sources,[double] $accuracy, [double] $ambientlight)  {
    $winning_object_color = $scene_objects[$index_of_winning_object].getColor()                                                   ###########
    $winning_object_normal = $scene_objects[$index_of_winning_object].getNormalAt($intersection_position)
    if ($winning_object_color.special -eq 2)  {
        # tiled floor pattern
        [int] $square = ([math]::floor($intersection_position.getVectX())) + ([math]::floor($intersection_position.getVectZ()))
        if (($square % 2) -eq 0)  {
            # black tile
            $winning_object_color.setColorRed(0.0)
            $winning_object_color.setColorGreen(0.0)
            $winning_object_color.setColorBlue(0.0)
        }
        else  {
            # white
            $winning_object_color.setColorRed(1.0)
            $winning_object_color.setColorGreen(1.0)
            $winning_object_color.setColorBlue(1.0)            
        }
    }
    $final_color = $winning_object_color.colorScaler($ambientlight)
    if ($winning_object_color.special -gt 0 -and $winning_object_color.special -le 1)  {                             
        # reflection from objects with specular intensity
        [double] $dot_1 = $winning_object_normal.dotProduct($intersection_direction.negative())
        [Vect] $scaler_1 = $winning_object_normal.vectMult($dot_1)
        [Vect] $add_1 = $scaler_1.vectAdd($intersection_direction)
        [Vect] $scaler_2 = $add_1.vectMult(2)
        [Vect] $add_2 = $intersection_direction.negative().vectAdd($scaler_2)
        [Vect] $reflection_direction = $add_2.normalize()
        $reflection_ray = [Ray]::new($intersection_position, $reflection_direction)
        # determine what the ray intersects with first
        $reflection_intersections = [Collections.ArrayList]@()
        for ($reflection_index = 0; $reflection_index -lt $scene_objects.count; $reflection_index++)  {
            $reflection_intersections.Add($scene_objects[$reflection_index].findIntersection($reflection_ray))
        }
        [int] $index_of_winning_object_with_reflection = WinningObjectIndex $reflection_intersections
        if ($index_of_winning_object_with_reflection -ne -1)  {
            # reflection ray missed everything else
            if ($reflection_intersections[$index_of_winning_object_with_reflection] -gt $accuracy)  {
                # determine the position and direction at the point of intersection with the reflection ray
                # the ray only affects the color if it reflected off something
                [Vect] $reflection_intersection_position = $intersection_position.vectAdd($reflection_direction.vectMult($reflection_intersections[$index_of_winning_object_with_reflection]))
                [Vect] $reflection_intersection_direction = $reflection_direction  
                $reflection_intersection_color = getColorAt $reflection_intersection_position $reflection_intersection_direction $scene_objects $index_of_winning_object_with_reflection $light_sources $accuracy $ambientlight
                $reflection_intersection_color_temp = [Color]::new()
                if ($reflection_intersection_color.getType().ToString() -eq 'System.Object[]' ) {
                    for ([int] $s_index = 0; $s_index -lt $reflection_intersection_color.count; $s_index++)  {
                        if  ( $reflection_intersection_color[$s_index].getType().Tostring() -eq 'Color')  {
                           $reflection_intersection_color_temp = $reflection_intersection_color[$s_index] 
                        }
                    }
                } 
                $reflection_intersection_color = $reflection_intersection_color_temp                  
                $final_color = $final_color.colorAdd($reflection_intersection_color.colorScaler($winning_object_color.special))
            }
        }
    }
    for ( [int] $light_index = 0; $light_index -lt $light_sources.count; $light_index++ )  {
        $light_direction = $light_sources[$light_index].getLightPosition().vectAdd($intersection_position.negative()).normalize()
        [double] $cosine_angle = $winning_object_normal.dotproduct($light_direction)
        if ( $cosine_angle -gt 0 )  {
            # test for shadow            
            [bool] $shadowed = $False
            $distance_to_light = $light_sources[$light_index].getLightPosition().vectAdd($intersection_position.negative()).normalize()
            $distance_to_light_magnitude = $distance_to_light.magnitude()
            $shadow_ray = [Ray]::new($intersection_position, $light_sources[$light_index].getLightPosition().vectAdd($intersection_position.negative()).normalize())
            $secondary_intersections = [Collections.ArrayList]@()
            for ( [int] $object_index = 0; $object_index -lt $scene_objects.count -and $shadowed -eq $False; $object_index++)  {
                $secondary_intersections.Add($scene_objects[$object_index].findIntersection($shadow_ray))    
            } 
            for([int] $c = 0; $c -lt $secondary_intersections.count; $c++)  {
                if ( $secondary_intersections[$c] -gt $accuracy )  {
                    if ($secondary_intersections[$c] -le $distance_to_light_magnitude)  {
                        $shadowed = $True                    
                    }
                    {break}
                }
            }
            if ($shadowed -eq $False)  {
                $final_color = $final_color.colorAdd($winning_object_color.colorMultiply($light_sources[$light_index].getLightColor()).colorScaler($cosine_angle))
                if ($winning_object_color.special -gt 0 -and $winning_object_color.special -le 1)  {
                    # special betwen 0 and 1, some reflective factor
                    [double] $dot_1 = $winning_object_normal.dotproduct($intersection_direction.negative())   
                    [Vect] $scaler_1 = $winning_object_normal.vectMult($dot_1)
                    [Vect] $add_1 = $scaler_1.vectAdd($intersection_direction)
                    [Vect] $scaler_2 = $add_1.vectMult(2)
                    [Vect] $add_2 = $intersection_direction.negative().vectAdd($scaler_2)
                    [Vect] $reflection_direction = $add_2.normalize()
                    [double] $specular = $reflection_direction.dotproduct($light_direction)
                    if ($specular -gt 0)  {
                        $specular = [math]::pow($specular, 10)  
                        $final_color = $final_color.colorAdd($light_sources[$light_index].getLightColor().colorScaler($specular * $winning_object_color.getColorSpecial())) 
                    }
                }
            }
        }
    }
    return [Color] $final_color.clip()   
}

function trace_bitmap ( [String]$filename )  {
    $s = date
    write-host 'tracing' $s
    [int] $width = 640 
    [int] $height = 480
    [int] $n = $width * $height
    [int] $aspect_ratio = $width / $height
    $bmp = New-Object Drawing.Bitmap($width, $height)
    [double] $ambientlight = 0.3
    [double] $accuracy = 0.001
    $vect_I = [Vect]::new(1,0,0)
    $vect_J = [Vect]::new(0,1,0)
    $vect_K = [Vect]::new(0,0,1)
    $vect_O = [Vect]::new(0,0,0)
    $vect_OO = [Vect]::new(1,0.5,0)
    $vect_Q = [Vect]::new(-1,1.5,0) 
    # camera objects
    $cam_pos = [Vect]::new(4, 1.3, -6)
    $look_at = [Vect]::new(-8, 0, 0)
    $diff_btw = [Vect]::new( $cam_pos.getVectX() - $look_at.getVectX(), $cam_pos.getVectY() - $look_at.getVectY(), $cam_pos.getVectZ() - $look_at.getVectZ() )
    $cam_dir = $diff_btw.negative().normalize()
    $cam_right = $vect_J.negative().crossproduct($cam_dir) 
    $cam_down = $cam_right.crossproduct($cam_dir)
    $scene_cam = [Camera]::new($cam_pos, $cam_dir, $cam_right, $cam_down)
    # colors
    $amber = [Color]::new( 0.8, 0.8, 0.6, 0 )
    $white = [Color]::new( 0.9, 0.9, 0.9, 0 )
    $soft_green = [Color]::new( 0.1, 0.4, 0.1, 0 )
    $gray = [Color]::new( 0.5, 0.5, 0.5, 0 )
    $black = [Color]::new( 0, 0, 0, 0 )
    $maroon = [Color]::new( 0.5, 0.0, 0.3, 0.2)
    $tile_floor = [Color]::new(1, 1, 1, 2)
    $purple = [Color]::new( 0.2, 0.1, 0.5, 0.4)
    # light objects
    $light_position = [Vect]::new(-7, 10, -10)
    $scene_light = [Light]::new($light_position,$white) 
    $light_position_2 = [Vect]::new(7, 10, -4)
    $scene_light_2 = [Light]::new($light_position_2,$amber)
    $light_sources = [Collections.ArrayList] @($scene_light, $scene_light_2)
    # scene objects
    $scene_sphere = [Sphere]::new($vect_OO, 0.5, $soft_green) 
    $scene_sphere_2 = [Sphere]::new($vect_Q, 1.5, $purple) 
    $scene_plane = [Plane]::new($vect_J, 0, $tile_floor)
    $scene_objects = @($scene_sphere,$scene_sphere_2, $scene_plane)
    for ($i_index = 0; $i_index -lt $width; $i_index++)  {
    write-output $i_index
        for ($j_index = 0; $j_index -lt $height; $j_index++)  {
            # write-output  'i' $i_index 'j' $j_index
            # no anti-aliasing
            if ( $width -gt $height )  {
               [double] $xamt = (($i_index + 0.5)/$width)*$aspect_ratio - (($width - $height) / ($height / 2))
               [double] $yamt = (($height - $j_index) + 0.5) / $height
            }
            elseif ($height -gt $width) {
               [double] $xamt = ($i_index + 0.5) / $width
               [double] $yamt = ((($height - $j_index) + 0.5) / $height) / $aspect_ratio - ((($height - $width) / $width) / 2)
            }     
            else  {
               [double] $xamt = ($i_index + 0.5)/$width
               [double] $yamt = (($height - $j_index) + 0.5) / $height
            }
            $cam_ray_origin = $scene_cam.getCameraPosition()
            $cam_ray_direction = $cam_dir.vectAdd($cam_right.vectMult($xamt - 0.5).vectAdd($cam_down.vectMult($yamt - 0.5))).normalize()
            $cam_ray = [Ray]::new($cam_ray_origin,$cam_ray_direction)  
            $intersections = [Collections.ArrayList]@()
            for ($index = 0; $index -lt $scene_objects.count; $index++)  {
                [void] $intersections.Add($scene_objects[$index].findIntersection($cam_ray)) 
            } 
           [int] $Index_of_winning_object = WinningObjectIndex $intersections

            if ( $Index_of_winning_object -eq -1 )  {
	            $bmp.SetPixel($i_index, $j_index, 'Black')
            }
            else  {
                # index corrisponds to and object in the scene
                $intersection_position = $cam_ray_origin.vectAdd($cam_ray_direction.vectMult($intersections[$index_of_winning_object]))
                $intersection_direction = $cam_ray_direction
                $intersection_color = getColorAt $intersection_position $intersection_direction  $scene_objects $index_of_winning_object $light_sources $accuracy $ambientlight
                $red_factor = $intersection_color.r * 255
                $green_factor = $intersection_color.g * 255                
                $blue_factor = $intersection_color.b * 255   
                $special_factor = $intersection_color.special * 255
                $color = [Drawing.Color]::FromArgb($red_factor,  $green_factor, $blue_factor)  
                $bmp.SetPixel($i_index, $j_index, $color)
            }
        }
    }
    $bmp.Save("c:\Temp\$filename.bmp")
    write-host 'start' $s
    $s = date
    write-host 'end' $s
}