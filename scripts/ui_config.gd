extends RefCounted
class_name UIConfig

const ZERO_FLOAT: float = 0.0
const NOT_FOUND_INDEX: int = -1
const DISPLAY_INDEX_OFFSET: int = 1

const LEFT_PANEL_WIDTH: float = 140.0
const RIGHT_PANEL_WIDTH: float = 170.0
const POWER_DECK_WIDTH: float = 120.0
const POWER_DECK_HEIGHT: float = 160.0
const HAND_CARD_WIDTH: float = 120.0
const HAND_CARD_HEIGHT: float = 140.0
const RESERVE_CARD_WIDTH: float = 120.0
const RESERVE_CARD_HEIGHT: float = 64.0
const ABILITY_BUTTON_WIDTH: float = 120.0
const ABILITY_BUTTON_HEIGHT: float = 42.0
const SECTION_TOP_MARGIN: float = 16.0
const DISCARD_BUTTON_WIDTH: float = 120.0
const DISCARD_BUTTON_HEIGHT: float = 50.0
const RESET_BUTTON_WIDTH: float = 120.0
const RESET_BUTTON_HEIGHT: float = 50.0
const END_TURN_TOP_MARGIN: float = 32.0

const MENU_BUTTON_WIDTH: float = 220.0
const MENU_BUTTON_HEIGHT: float = 56.0
const MENU_BUTTON_SEPARATION: int = 18

const SCREEN_TITLE_BOTTOM_MARGIN: float = 32.0

const RULES_SCREEN_MARGIN: int = 36
const RULES_TEXT_WIDTH: float = 820.0
const RULES_TEXT_HEIGHT: float = 580.0
const RULES_BACK_TOP_MARGIN: float = 24.0

const LAYOUT_PADDING: float = 32.0
const MIN_AVAILABLE_SIZE: float = 1.0
const MIN_LAYOUT_SCALE: float = 0.65
const MAX_LAYOUT_SCALE: float = 1.15
const CENTER_DIVISOR: float = 2.0
const DOUBLE_MULTIPLIER: float = 2.0
const ZERO_VECTOR: Vector2 = Vector2(0.0, 0.0)

const SCREEN_MARGIN: int = 16
const MAIN_SEPARATION: int = 10
const ROW_SEPARATION: int = 8
const CONTENT_SEPARATION: int = 24
const PANEL_SEPARATION: int = 12

const SLOT_SIZE: Vector2 = Vector2(80, 100)

const THEME_MARGIN_LEFT: String = "margin_left"
const THEME_MARGIN_TOP: String = "margin_top"
const THEME_MARGIN_RIGHT: String = "margin_right"
const THEME_MARGIN_BOTTOM: String = "margin_bottom"
const THEME_SEPARATION: String = "separation"

const EMPTY_TEXT: String = ""
const TEXT_TITLE: String = "Clear the Dungeon"
const TEXT_INITIAL_MESSAGE: String = "Play cards or press End Turn."
const TEXT_HAND: String = "Hand"
const TEXT_POWER_RESERVE: String = "Reserve"
const TEXT_SET_RESERVE: String = "Set Reserve"
const TEXT_SPECIAL_ABILITIES: String = "Abilities"
const TEXT_DOUBLE_PENDING: String = "Next card x2"
const TEXT_EMPTY: String = "Empty"
const TEXT_HIDDEN: String = "Hidden"
const TEXT_TAKE_LOOT: String = "Take"
const TEXT_POWER_DECK_FORMAT: String = "Power\nDeck\n%d cards"
const TEXT_CLEAR_PILE_FORMAT: String = "Clear pile: %d"
const TEXT_SELECTED_CARD_FORMAT: String = "[%d]\n%s"
const TEXT_MONSTER_STATUS_FORMAT: String = "%s has %d/3 attack cards."
const TEXT_LOOT_STATUS: String = "Joker loot. Click it with hand space to pick it up."
const TEXT_HIDDEN_STATUS: String = "That card is still covered."
const TEXT_SLOT_EMPTY_STATUS: String = "That slot is already empty."
const TEXT_CHOOSE_CARD: String = "Choose a card."
const TEXT_RESET: String = "Reset"
const TEXT_MAIN_MENU: String = "Main Menu"
const TEXT_GAME_RESET: String = "Game reset. New hand drawn."
const TEXT_END_TURN: String = "End Turn"
const TEXT_AUTO_END_TURN_PREFIX: String = "No cards left. Auto end turn: "
const TEXT_MONSTER_DAMAGE_FORMAT: String = "\n\n%d/%d"
const TEXT_MONSTER_KILL_READY: String = "\n\nKill ready"

const TEXT_DIAMOND_TOP: String = "Top"
const TEXT_DIAMOND_LEAVE: String = "Leave"
const TEXT_DIAMOND_BOTTOM_FORMAT: String = "Bottom: %s"

const TEXT_LIFE_HEART: String = "♥"
const TEXT_LIFE_SEPARATOR: String = " "
const TEXT_NO_LIFE: String = ""
const LIFE_HEARTS_PER_ROW: int = 4
const TEXT_LIFE_LINE_BREAK: String = "\n"

const TEXT_MENU_PLAY: String = "Play"
const TEXT_MENU_RULES: String = "Rules"
const TEXT_MENU_QUIT: String = "Quit"

const TEXT_VARIATION_SELECT_TITLE: String = "Choose Variations"

const VARIATION_SELECT_SCREEN_MARGIN: int = 36
const VARIATION_OPTION_SEPARATION: int = 14
const VARIATION_BUTTON_WIDTH: float = 420.0
const VARIATION_BUTTON_HEIGHT: float = 64.0
const VARIATION_BUTTONS_TOP_MARGIN: float = 28.0

const TEXT_LAYOUT_SELECT_TITLE: String = "Choose Layout"
const TEXT_LAYOUT_BUTTON_FORMAT: String = "%s\n\n%s"

const LAYOUT_SELECT_SCREEN_MARGIN: int = 36
const LAYOUT_OPTIONS_MIN_HEIGHT: float = 420.0
const LAYOUT_OPTIONS_HORIZONTAL_SEPARATION: int = 24
const LAYOUT_OPTIONS_VERTICAL_SEPARATION: int = 24
const LAYOUT_BACK_TOP_MARGIN: float = 24.0

const LAYOUT_BUTTON_WIDTH: float = 300.0
const LAYOUT_BUTTON_HEIGHT: float = 180.0

const TEXT_RULES_TITLE: String = "Rules"
const TEXT_BACK: String = "Back"

const TEXT_RULES_BODY: String = """
[center][font_size=26][b]CLEAR THE DUNGEON - RULES[/b][/font_size][/center]

[font_size=22][b]Objective[/b][/font_size]
Destroy all dungeon monsters before your power deck runs out.

[font_size=22][b]Players[/b][/font_size]
1 player.

[font_size=22][b]Materials[/b][/font_size]
Use a 54-card deck: Ace through King plus two Jokers.

[font_size=22][b]Ranking[/b][/font_size]
Aces are low in the base game. Cards rank from Ace to King. Jokers are wild.

[font_size=22][b]Setup[/b][/font_size]
Separate the face cards from the deck: Jacks, Queens, and Kings. These twelve cards form the dungeon monster deck.

The rest of the cards form the power deck. In the official setup, the power deck contains Aces through 10s plus the two Jokers.

Cards are placed face down in a dungeon layout. A card is revealed only when it is no longer covered by cards below it.

In this prototype, the special 14-card layout places the two Jokers inside the dungeon as loot. The other 12-card layouts keep the Jokers in the power deck.

[font_size=22][b]Turn Structure[/b][/font_size]
Each turn has three phases:

Draw
Attack
Discard

In this digital version, the first hand is drawn automatically. Press End Turn to discard remaining hand cards and draw a new hand.

[font_size=22][b]Draw[/b][/font_size]
Draw three cards from the power deck. These cards become your hand.

Every card in your hand must be played or discarded before the next hand is drawn.

[font_size=22][b]Attack[/b][/font_size]
Each monster has a power level:

Jack = 11
Queen = 12
King = 13

To defeat a monster, place exactly three cards on it.

The first two cards are attack cards. Add their values together. Their suits do not matter.

The total of the first two cards must be equal to or greater than the monster's power level.

The third card is the trigger card. Its rank does not matter, but its suit must match the monster's suit.

Example:
To defeat a Jack of Hearts, the first two attack cards must add up to at least 11. The third card must be a Heart.

When the third card is played and the attack is valid, the monster is defeated. The monster and its attack cards go to the clear pile. Newly uncovered cards become available.

[font_size=22][b]Jokers[/b][/font_size]
Jokers can be used as attack cards or as trigger cards.

As an attack card, a Joker has value 10.

As a trigger card, a Joker can count as any suit.

In the current 14-card layout, Jokers appear in the dungeon as loot. When uncovered, a Joker can be taken into your hand if you have space.

[font_size=22][b]Damage Bar[/b][/font_size]
Cards that are not played, or that you choose not to play, are discarded before drawing your next hand.

These discarded cards form your damage bar.

If your damage bar reaches seven cards, you lose immediately.

[font_size=22][b]Win[/b][/font_size]
You win if all dungeon monsters are defeated before the power deck runs out.

[font_size=22][b]Score[/b][/font_size]
Your score is the number of cards remaining in the power deck.

Cards still in your hand do not count toward your score.

[font_size=22][b]Dungeon Layouts[/b][/font_size]
A card is unlocked when all cards directly below it have been cleared.

If a card only has one card directly below it, clearing that single lower card is enough to unlock it.

Layout 1:
[code]
[X] [X] [X] [X]
[X] [X] [X] [X]
[X] [X] [X] [X]
[/code]

Layout 2:
[code]
[X] [X] [X]
[X] [X] [X]
[X] [X] [X]
[X] [X] [X]
[/code]

Layout 3:
[code]
      [X] [X]
   [X] [X] [X]
   [X] [X] [X]
[X] [X] [X] [X]
[/code]

Layout 4:
[code]
   [X] [X]
   [X] [X]
[X] [X] [X]
   [X] [X]
[X] [X] [X]
[/code]

Layout 5:
[code]
       [X]
    [X] [X]
 [X] [X] [X]
   [X] [X]
       [X]
    [X] [X]
 [X] [X] [X]
[/code]

[font_size=22][b]Variations[/b][/font_size]

[font_size=22][b]Boomer-Ace[/b][/font_size]
Aces are worth 11 instead of 1.

If an Ace is used as a trigger card, it returns to your hand after the attack.

[font_size=22][b]Power Reserve[/b][/font_size]
At the beginning of the first turn, draw five cards instead of three.

Choose two of those five cards and place them aside as your power reserve.

Power reserve cards are face up and may be used at any time as attack cards or trigger cards.

The reserve cannot be refilled. Once those cards are used, they are gone.

Each unused power reserve card remaining after a win adds one point to your score.

[font_size=22][b]Special Abilities[/b][/font_size]
Defeated Kings can become special ability cards.

King of Hearts:
Place one card from your hand at the bottom of the power deck.

King of Diamonds:
Look at the bottom card of the power deck. You may move it to the top.

King of Spades:
Double the value of one attack card.

King of Clubs:
Immediately draw one card from the power deck.

Once a King ability is used, that King is discarded with the destroyed monster and the cards used in that attack.
"""
