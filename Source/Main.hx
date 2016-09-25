/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package;

import openfl.display.Sprite;

import game.Stage;


class Main extends Sprite {
	var game:Stage;

	public function new() {
		super();
		game = new Stage(this, 14, 11);
		game.start();
	}
}
