# Clear the Dungeon

**Clear the Dungeon** is a single-player card game about clearing a dungeon full of monsters before your power runs out.

This digital version was built in **Godot 4** as a graphical adaptation of the original solitaire card game. The player must reveal dungeon cards, defeat monsters using attack combinations, manage their hand, and avoid losing all hearts.

## Creator

Original card game created by **Mark S. Ball**.

---

## Game Objective

Destroy all dungeon monsters before running out of cards in the power deck or losing all hearts.

You win if every monster in the dungeon is defeated.

You lose if your damage reaches the limit.

---

## Materials

The game uses a standard 54-card deck:

- Ace through King in four suits.
- Two Jokers.

In the base rules:

- Jacks, Queens, and Kings are monsters.
- Aces through 10s are power cards.
- Jokers are wild power cards.

In this digital version, most layouts use Jokers in the power deck. The special 14-card layout places the two Jokers inside the dungeon as loot.

---

## Card Values

### Power Cards

| Card | Value |
|---|---:|
| Ace | 1 |
| 2-10 | Printed value |
| Joker | 10 |

### Monster Cards

| Monster | Power |
|---|---:|
| Jack | 11 |
| Queen | 12 |
| King | 13 |

---

## Suits

The game uses the four normal card suits:

- Hearts: `♥`
- Diamonds: `♦`
- Clubs: `♣`
- Spades: `♠`

The third card used to defeat a monster is called the **trigger card**, and its suit must match the monster's suit.

A Joker can be used as any suit.

---

## Dungeon Layouts

The dungeon is made of face-down cards arranged in a layout.

A card can only be revealed when the cards directly below it have been cleared.

If a card has two cards below it, both must be cleared.

If a card has only one card below it, only that card must be cleared.

Available layouts:

### Layout 1

    [X] [X] [X] [X]
    [X] [X] [X] [X]
    [X] [X] [X] [X]

### Layout 2

    [X] [X] [X]
    [X] [X] [X]
    [X] [X] [X]
    [X] [X] [X]

### Layout 3

      [X] [X]
     [X] [X] [X]
     [X] [X] [X]
    [X] [X] [X] [X]

### Layout 4

     [X] [X]
     [X] [X]
    [X] [X] [X]
     [X] [X]
    [X] [X] [X]

### Layout 5

       [X]
      [X] [X]
     [X] [X] [X]
      [X] [X]
       [X]
      [X] [X]
     [X] [X] [X]

The last layout contains 14 dungeon cards, so the two Jokers are placed in the dungeon as loot.

---

## Turn Structure

Each turn follows this structure:

1. Draw cards.
2. Play cards on monsters.
3. End the turn and discard unused cards.

In this digital version, the first hand is drawn automatically.

At the end of a turn, any cards still in your hand are discarded, and you draw a new hand.

---

## Drawing Cards

At the start of a turn, draw 3 cards from the power deck.

These cards become your hand.

You can use them to attack monsters, trigger attacks, pick up available Joker loot, or leave them unused.

Unused cards are discarded when you end the turn.

---

## Attacking Monsters

To defeat a monster, you must place exactly 3 cards on it.

The first two cards are attack cards.

Their values are added together.

The third card is the trigger card.

### Attack Requirement

The first two attack cards must have a combined value equal to or greater than the monster's power.

Monster powers:

| Monster | Required Power |
|---|---:|
| Jack | 11 |
| Queen | 12 |
| King | 13 |

So, to defeat a Queen, the first two cards must add up to at least 12.

### Trigger Requirement

The third card must match the monster's suit.

Example:

    Monster: Q♥

    Attack cards:
    7♣ + 5♠ = 12

    Trigger:
    Any Heart card

This defeats the Queen of Hearts.

A Joker can be used as the trigger for any suit.

---

## Jokers

Jokers are wild cards.

A Joker can be used as:

- An attack card with value 10.
- A trigger card of any suit.

In the special 14-card layout, Jokers appear in the dungeon as loot.

When a Joker loot card is revealed, you can take it into your hand if you have space.

---

## Hearts / Damage

Instead of showing damage as a number, this version shows hearts.

You start with 7 hearts.

Each discarded card removes 1 heart.

Example:

    Start:
    ♥ ♥ ♥ ♥
    ♥ ♥ ♥

    After discarding 2 cards:
    ♥ ♥ ♥ ♥
    ♥

If you lose all hearts, you lose the game.

---

## End Turn

Press **End Turn** to finish your current turn.

When you end your turn:

1. Any cards still in your hand are discarded.
2. You lose hearts equal to the number of discarded cards.
3. You draw a new hand of 3 cards.

If your hand becomes empty and there is no accessible Joker loot, the game can automatically advance to the next turn.

---

## Clear Pile

When a monster is defeated:

- The monster goes to the clear pile.
- The cards used to defeat it also go to the clear pile.
- Any newly uncovered dungeon cards are revealed.

The clear pile shows how many cards have been cleared.

---

## Winning

You win when all dungeon monsters are defeated.

Your score is the number of cards remaining in the power deck.

Cards still in your hand do not count toward your score.

---

## Losing

You lose if:

- You lose all hearts.
- The power deck runs out before the dungeon is cleared.

---

## Variations

The following variations are part of the original game rules, but may not all be implemented in this digital version yet.

### Boomer-Ace

Aces are worth 11 instead of 1.

If an Ace is used as a trigger card, it returns to your hand after the attack.

### Power Reserve

At the beginning of the first turn, draw 5 cards instead of 3.

Choose 2 of those cards and place them aside as your power reserve.

Power reserve cards are face up and may be used at any time as attack cards or trigger cards.

The reserve cannot be refilled.

Each unused power reserve card remaining after a win adds 1 point to your score.

### Special Abilities

Defeated Kings can grant special abilities.

Place defeated Kings face up in an inventory row.

| King | Ability |
|---|---|
| K♥ | Place one card from your hand at the bottom of the power deck. |
| K♦ | Look at the bottom card of the power deck and move it to the top if desired. |
| K♠ | Double the value of one attack card. |
| K♣ | Immediately draw one card from the power deck. |

Once a King ability is used, that King is discarded with the destroyed monster and the cards used in the attack.

---

## Controls

### Main Menu

- **Play**: go to layout selection.
- **Rules**: read the rules.
- **Quit**: close the game.

### Layout Selection

Choose one of the available dungeon layouts.

### During the Game

- Click a hand card to select or unselect it.
- Click a revealed monster to place selected cards on it.
- Click an accessible Joker loot card to take it into your hand.
- Press **End Turn** to discard remaining cards and draw again.
- Press **Reset** to restart the current game.
- Press **Main Menu** to return to the main menu.

