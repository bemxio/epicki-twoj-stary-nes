# Epicki Twój Stary NES
An NES port of [Epicki Twój Stary](https://www.rinnegatamante.eu/vitadb/#/info/1160), made by [Domino](https://www.youtube.com/@D00m1no) for the PlayStation Vita.

## Compatibility
This game uses mapper 1 (MMC1, more specifically SGROM). If Mega Man 2 works on your emulator/flashcart, this should too.

## Building
To build the game, you will need [cc65](https://cc65.github.io) and [Make](https://www.gnu.org/software/make). After installing both, run the following command in the root of the repository:

```bash
make
```

The `EpickiTwojStary.nes` ROM file should appear in the `build` directory after the build is complete.

If you've got [Mesen](https://www.mesen.ca) or [FCEUX](https://fceux.com/web/home.html) installed, you can also build and run the game with the following command(s):

```bash
# Mesen
make run

# FCEUX
make run-fceux
```

## License
This project is licensed under the MIT License - see the [`LICENSE`](LICENSE) file for details.

Contributions are welcome! If you want to contribute, whether it's a bug you've encountered or a pull request with new features, feel free to do so.