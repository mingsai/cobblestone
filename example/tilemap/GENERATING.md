Tile images for the Collection of Images map type can be cropped from the original tileset by using the ImageMagick command ```convert floating_islands.png -crop 16x16 atlas/tile%d.png```. 

These are then packed using the [LibGDX Texture Packer](https://github.com/libgdx/libgdx/wiki/Texture-packer) called via ```java -jar runnable-texturepacker.jar atlas . atlas```. This will load the settings stored in ```atlas/pack.json```.

The extruded tileset for the Tileset Image map type can be created using the [Phaser Tile Extruder](https://github.com/sporadic-labs/tile-extruder) with the command ```tile-extruder --tileWidth 16 --tileHeight 16 --input floating_islands.png --output floating_islands_extruded```.