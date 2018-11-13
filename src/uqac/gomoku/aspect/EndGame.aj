package uqac.gomoku.aspect;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

import javafx.scene.paint.Color;
import uqac.gomoku.core.Player;
import uqac.gomoku.core.model.Grid;
import uqac.gomoku.core.model.Spot;
import uqac.gomoku.ui.Board;

public aspect EndGame {
	boolean isOver = false;
	boolean firstTime = true;
	Board refBoard = null;

	pointcut verifyWin(Player p):
		call (void Grid.notifyGameOver(Player)) && args(p);

	pointcut verifyDraw():
		call (void Grid.notifyGameOver(null));

	pointcut blockGame(): execution (* placeStone(..));

	pointcut getRef(): 
		call (* *.setCenter(playGround));

	pointcut getWinningStones(List<Spot> liste):
		(set(List<Spot> Grid.winningStones)) && args(liste);

	pointcut getBoard():
		execution(Board.new(..)) && !within(ObjectCreationAspect);

	after() : getBoard() {
		this.refBoard = ((Board) thisJoinPoint.getThis());
	}

	void around(): blockGame() {
		if (this.isOver) {
			if (this.firstTime) {
				System.out.println("Game is over stop trying to play!");
				firstTime = false;
			}
		} else {
			proceed();
		}
	}

	after(): verifyDraw() {
		System.out.println("The grid is full");
		this.isOver = true;
	}

	after(Player p): verifyWin(p) {
		System.out.println("Le joueur " + p.getName() + " a gagne");
		isOver = true;
	}

	after(List<Spot> liste): getWinningStones(liste) {
		Player p = new Player("gagnant", Color.GOLD);

		liste.forEach(l -> {
			try {
				Method setOccupant = l.getClass().getDeclaredMethod("setOccupant", Player.class);
				setOccupant.setAccessible(true);
				try {
					setOccupant.invoke(l, p);

					Method drawStone = refBoard.getClass().getDeclaredMethod("drawStone", Spot.class);
					drawStone.setAccessible(true);

					drawStone.invoke(this.refBoard, l);

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			} catch (NoSuchMethodException e) {
				e.printStackTrace();
			} catch (SecurityException e) {
				e.printStackTrace();
			}
		});

	}

}
