/*
 * ----------------------------------------------------------------------------
 * "THE THE-WARE LICENSE":
 * Jebril A.R. wrote this bit of code.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy/make me a cup of Tea in return.
 * ----------------------------------------------------------------------------
 */
package uqac.gomoku.core;

import uqac.gomoku.core.model.Spot;

public interface BoardEventListener {
	void spotClicked(Spot place);
}
