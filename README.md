# cobblestone

A Dart game framework inspired by [LibGDX](https://libgdx.badlogicgames.com/).

Cobblestone provides the basic features of game rendering, audio playing, and asset management,
allowing the user to build any sort of gameplay without worrying about these lower level features.

More advanced features of the engine include:

- Texture Atlas support, as created by the [LibGDX TexturePacker](https://github.com/libgdx/libgdx/wiki/Texture-packer)
- Tween animations
- Bitmap Font Rendering
- [Tiled](https://www.mapeditor.org/) .tmx map loading and rendering
- Particle systems, as exported by the [PixiJS Particle Editor](https://pixijs.io/pixi-particles-editor/)
- Custom rendering, including framebuffers, glsl shaders, or a fully custom pipeline

## License

Cobblestone is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Issues and Contributing

Feel free to report any bugs, or make suggestions for improvements on the 
[Issue Tracker](https://gitlab.com/ectucker/cobblestone/issues).

Also take a look at the [Contribution Guide](CONTRIBUTING.md). 

## Demos

Engine demos can be found [here](https://ectucker.gitlab.io/cobblestone/)
or by cloning the repo and running `pub serve example`.

Other examples can be seen in [these Ludum Dare entries](https://ldjam.com/users/ectucker1/games). 
Be warned, most of those use older engine versions and will not compile with the latest updates.

## Tutorials and Getting Started

The [Wiki](https://gitlab.com/ectucker/cobblestone/wikis/Home) on GitLab
hosts tutorials and guides for using the framework.


The [Basic Game Tutorial](https://gitlab.com/ectucker/cobblestone/wikis/A-Basic-Game)
goes over the full process of setting up a project and creating a game.

Full code documentation will be available online once the package is published to pub.
In the meantime, documentation can be viewed by cloning the repository and running ```dartdoc```.