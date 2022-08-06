-----------------------------------------------------------------------
--
-- 	Haskell: The Craft of Functional Programming, 3e
-- 	Simon Thompson
-- 	(c) Addison-Wesley, 1996-2011.
-- 
-- 	PicturesSVG
--
--      The Pictures functionality implemented by translation  
--      SVG (Scalable Vector Graphics)
--
--      These Pictures could be rendered by conversion to ASCII art,
--      but instead are rendered into SVG, which can then be viewed in 
--      a browser: google chrome does a good job. 
--
-----------------------------------------------------------------------


module ImagenesSVG where

import System.IO

-- Pictures represened by a type of trees, so this is a deep
-- embedding.

data Imagen 
 = Img Image 
 | Above Imagen Imagen
 | Beside Imagen Imagen
 | Over Imagen Imagen
 | FlipH Imagen
 | FlipV Imagen
 | Negative Imagen
   deriving (Show)

-- Coordinates are pairs (x,y) of integers
--
--  o------> x axis
--  |
--  |
--  V
--  y axis


type Point = (Int,Int)

-- The Point in an Image gives the dimensions of the image in pixels.

data Image = Image Name Point
             deriving (Show)

data Name  = Name String
             deriving (Show)

--
-- The functions over Pictures
--

encima, junto_a, sobre :: Imagen -> Imagen -> Imagen 

encima  = Above
junto_a = Beside
sobre   = Over
 
-- flipH is flip in a horizontal axis
-- flipV is flip in a vertical axis
-- negative negates each pixel

-- The definitions of flipH, flipV, negative push the 
-- constructors through the binary operations to the images 
-- at the leaves.

-- Original implementation incorrect: it pushed the 
-- flipH and flipV through all constructors ... 
-- Now it distributes appropriately over Above, Beside and Over.

giraH, giraV, negative :: Imagen -> Imagen 

giraH (Above pic1 pic2)  = (giraH pic2) `Above` (giraH pic1)
giraH (Beside pic1 pic2) = (giraH pic1) `Beside` (giraH pic2)
giraH (Over pic1 pic2)   = (giraH pic1) `Over` (giraH pic2)
giraH pic                = FlipH pic

giraV (Above pic1 pic2)  = (giraV pic1) `Above` (giraV pic2)
giraV (Beside pic1 pic2) = (giraV pic2) `Beside` (giraV pic1)
giraV (Over pic1 pic2)   = (giraV pic1) `Over` (giraV pic2)
giraV pic                = FlipV pic

negative = Negative

invierte_color = Negative

-- Convert an Image to a Imagen

img :: Image -> Imagen 

img = Img

--
-- Library functions
--

-- Dimensions of pictures

width,height :: Imagen -> Int

width (Img (Image _ (x,_))) = x 
width (Above pic1 pic2)     = max (width pic1) (width pic2)
width (Beside pic1 pic2)    = (width pic1) + (width pic2)
width (Over pic1 pic2)      = max (width pic1) (width pic2)
width (FlipH pic)           = width pic
width (FlipV pic)           = width pic
width (Negative pic)        = width pic

height (Img (Image _ (x,y))) = y 
height (Above pic1 pic2)     = (height pic1) + (height pic2)
height (Beside pic1 pic2)    = max (height pic1) (height pic2)
height (Over pic1 pic2)      = max (height pic1) (height pic2)
height (FlipH pic)           = height pic
height (FlipV pic)           = height pic
height (Negative pic)        = height pic

--
-- Converting pictures to a list of basic images.
--

-- A Filter represents which of the actions of flipH, flipV 
-- and negative is to be applied to an image in forming a
-- Basic picture.

data Filter = Filter {fH, fV, neg :: Bool}
              deriving (Show)

newFilter = Filter False False False

data Basic = Basic Image Point Filter
             deriving (Show)

-- Flatten a picture into a list of Basic pictures.
-- The Point argument gives the origin for the coversion of the
-- argument.

flatten :: Point -> Imagen -> [Basic]

flatten (x,y) (Img image)        = [Basic image (x,y) newFilter] 
flatten (x,y) (Above pic1 pic2)  = flatten (x,y) pic1 ++ flatten (x, y + height pic1) pic2
flatten (x,y) (Beside pic1 pic2) = flatten (x,y) pic1 ++ flatten (x + width pic1 , y) pic2
flatten (x,y) (Over pic1 pic2)   = flatten (x,y) pic1 ++ flatten (x,y) pic2
flatten (x,y) (FlipH pic)        = map giraFH $ flatten (x,y) pic
flatten (x,y) (FlipV pic)        = map giraFV $ flatten (x,y) pic
flatten (x,y) (Negative pic)     = map flipNeg $ flatten (x,y) pic

-- flip one of the flags for transforms / filter

giraFH (Basic img (x,y) f@(Filter {fH=boo}))   = Basic img (x,y) f{fH = not boo}
giraFV (Basic img (x,y) f@(Filter {fV=boo}))   = Basic img (x,y) f{fV = not boo}
flipNeg (Basic img (x,y) f@(Filter {neg=boo})) = Basic img (x,y) f{neg = not boo}

--
-- Convert a Basic picture to an SVG image, represented by a String.
--

convert :: Basic -> String

convert (Basic (Image (Name name) (width, height)) (x,y) (Filter fH fV neg))
  = "\n  <image x=\"" ++ show x ++ "\" y=\"" ++ show y ++ "\" width=\"" ++ show width ++ "\" height=\"" ++
    show height ++ "\" xlink:href=\"" ++ name ++ "\"" ++ flipPart ++ negPart ++ "/>\n"
        where
          flipPart 
              = if      fH && not fV 
                then " transform=\"translate(0," ++ show (2*y + height) ++ ") scale(1,-1)\" " 
                else if fV && not fH 
                then " transform=\"translate(" ++ show (2*x + width) ++ ",0) scale(-1,1)\" " 
                else if fV && fH 
                then " transform=\"translate(" ++ show (2*x + width) ++ "," ++ show (2*y + height) ++ ") scale(-1,-1)\" " 
                else ""
          negPart 
              = if neg 
                then " filter=\"url(#negative)\"" 
                else "" 

-- Outputting a picture.
-- The effect of this is to write the SVG code into a file
-- whose path is hardwired into the code. Could easily modify so
-- that it is an argument of the call, and indeed could also call
-- the browser to update on output.

imprime :: Imagen -> IO ()

imprime pic 
 = 
   let
       picList = flatten (0,0) pic
       svgString = concat (map convert picList)
       newFile = preamble ++ svgString ++ postamble
   in
     do
       outh <- openFile "svgOut.xml" WriteMode
       hPutStrLn outh newFile
       hClose outh

-- Preamble and postamble: boilerplate XML code. 

preamble
 = "<svg width=\"100%\" height=\"100%\" version=\"1.1\"\n" ++
   "xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n" ++
   "<filter id=\"negative\">\n" ++
   "<feColorMatrix type=\"matrix\"\n"++
   "values=\"-1 0  0  0  0  0 -1  0  0  0  0  0 -1  0  0  1  1  1  0  0\" />\n" ++
   "</filter>\n"

postamble
 = "\n</svg>\n"

--
-- Examples
--

blanco = Img $ Image (Name "white.jpg") (50, 50)

negro = Img $ Image (Name "black.jpg") (50, 50)

caballo = Img $ Image (Name "blk_horse_head.jpg") (150, 200)

caballoPequeño = Img $ Image (Name "blk_horse_head.jpg") (50, 50)
