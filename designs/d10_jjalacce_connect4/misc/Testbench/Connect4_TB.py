import cocotb
from cocotb.clock import Clock
from cocotb.triggers import *
from cocotb.handle import *
from PIL import Image, ImageDraw, ImageChops
import math



@cocotb.test()
async def player_turn_logic_test_PVP(dut):
    print("============== STARTING TEST ==============")
    # Run the clock
    #Creates a 25MHz clock
    print("Starting clock")
    cocotb.start_soon(Clock(dut.clock, 40, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clock)

    # Reset the DUT
    print("Reseting")
    dut.reset.value = True
    await FallingEdge(dut.clock)
    await FallingEdge(dut.clock)
    dut.reset.value = False
    print("Reset Complete")

    print("Setting to PVP")
    await FallingEdge(dut.clock)
    dut.inputSwitchPVP.value = 1

    #make move in row 1 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 1 player 1")
    dut.inputMoves.value = 1
    dut.inputConfirm.value = 1
    dut.inputSwitchPlayer.value = 0

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 1)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 1)
    assert (dut.owner.player_1_input.value == 1)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 0)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 1 for player 2
    print("Making move in row 1 player 2")
    dut.inputMoves.value = 1
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 1)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 1)
    assert (dut.owner.player_2_input.value == 1)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 0)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 2 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 2 player 1")
    dut.inputMoves.value = 2
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 2)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 2)
    assert (dut.owner.player_1_input.value == 2)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 1)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 2 for player 2
    print("Making move in row 2 player 2")
    dut.inputMoves.value = 2
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 2)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 2)
    assert (dut.owner.player_2_input.value == 2)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 1)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 3 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 3 player 1")
    dut.inputMoves.value = 4
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 4)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 4)
    assert (dut.owner.player_1_input.value == 4)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 2)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 3 for player 2
    print("Making move in row 3 player 2")
    dut.inputMoves.value = 4
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 4)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 4)
    assert (dut.owner.player_2_input.value == 4)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 2)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 4 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 4 player 1")
    dut.inputMoves.value = 8
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 8)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 8)
    assert (dut.owner.player_1_input.value == 8)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 3)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 4 for player 2
    print("Making move in row 4 player 2")
    dut.inputMoves.value = 8
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 8)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 8)
    assert (dut.owner.player_2_input.value == 8)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 3)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 5 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 5 player 1")
    dut.inputMoves.value = 16
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 16)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 16)
    assert (dut.owner.player_1_input.value == 16)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 4)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 5 for player 2
    print("Making move in row 5 player 2")
    dut.inputMoves.value = 16
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 16)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 16)
    assert (dut.owner.player_2_input.value == 16)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 4)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 6 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 6 player 1")
    dut.inputMoves.value = 32
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 32)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 32)
    assert (dut.owner.player_1_input.value == 32)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 5)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 6 for player 2
    print("Making move in row 6 player 2")
    dut.inputMoves.value = 32
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 32)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 32)
    assert (dut.owner.player_2_input.value == 32)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 5)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 7 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 7 player 1")
    dut.inputMoves.value = 64
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 64)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 64)
    assert (dut.owner.player_1_input.value == 64)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 6)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 7 for player 2
    print("Making move in row 7 player 2")
    dut.inputMoves.value = 64
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 64)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 64)
    assert (dut.owner.player_2_input.value == 64)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == 6)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)


@cocotb.test()
async def player_turn_logic_test_PVE(dut):
    print("============== STARTING TEST ==============")
    # Run the clock
    #Creates a 25MHz clock
    print("Starting clock")
    cocotb.start_soon(Clock(dut.clock, 40, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clock)

    # Reset the DUT
    print("Reseting")
    dut.reset.value = True
    await FallingEdge(dut.clock)
    await FallingEdge(dut.clock)
    dut.reset.value = False
    print("Reset Complete")

    print("Setting to PVE")
    await FallingEdge(dut.clock)
    dut.inputSwitchPVP.value = 0

    #make move in row 1 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 1 player 1")
    dut.inputMoves.value = 1
    dut.inputConfirm.value = 1
    dut.inputSwitchPlayer.value = 0

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 1)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 1)
    assert (dut.owner.player_1_input.value == 1)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 0)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 1 for player 2
    print("Making move in row 1 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 2 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 2 player 1")
    dut.inputMoves.value = 2
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 2)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 2)
    assert (dut.owner.player_1_input.value == 2)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 1)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 2 for player 2
    print("Making move in row 2 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 3 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 3 player 1")
    dut.inputMoves.value = 4
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 4)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 4)
    assert (dut.owner.player_1_input.value == 4)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 2)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 3 for player 2
    print("Making move in row 3 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 4 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 4 player 1")
    dut.inputMoves.value = 8
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 8)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 8)
    assert (dut.owner.player_1_input.value == 8)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 3)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 4 for player 2
    print("Making move in row 4 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 5 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 5 player 1")
    dut.inputMoves.value = 16
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 16)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 16)
    assert (dut.owner.player_1_input.value == 16)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 4)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 5 for player 2
    print("Making move in row 5 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 6 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 6 player 1")
    dut.inputMoves.value = 32
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 32)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 32)
    assert (dut.owner.player_1_input.value == 32)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 5)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 6 for player 2
    print("Making move in row 6 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)

    #make move in row 7 for player 1
    await FallingEdge(dut.clock)
    print("Making move in row 7 player 1")
    dut.inputMoves.value = 64
    dut.inputConfirm.value = 1

    #Goes through first sync DFF
    await FallingEdge(dut.clock)
    #turns off confirm
    dut.inputConfirm.value = 0
    assert (dut.inputMovesHalf.value == 64)
    #Goes through second sync DFF
    #and goes through logic to change next clocks tokens
    await FallingEdge(dut.clock)
    assert (dut.inputMovesSync.value == 64)
    assert (dut.owner.player_1_input.value == 64)
    assert (dut.owner.currentPlayer.value == 0)
    assert (dut.owner.move.value == 6)
    await FallingEdge(dut.clock)
    assert (dut.owner.set.value == 1)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 1
    await FallingEdge(dut.clock)
    #make move in row 7 for player 2
    print("Making move in row 7 player 2")
    await FallingEdge(dut.clock)
    #turns off confirm
    await RisingEdge(dut.bot_confirm)
    print("Bots selected move is "+str(dut.player_2_input.value))
    bot_move = dut.player_2_input.value
    await FallingEdge(dut.clock)
    assert (dut.owner.player_2_input.value == bot_move)
    assert (dut.owner.currentPlayer.value == 1)
    assert (dut.owner.move.value == math.log2(bot_move))
    assert (dut.owner.set.value == 2)
    #tokens is changed
    await FallingEdge(dut.clock)
    dut.inputSwitchPlayer.value = 0
    await FallingEdge(dut.clock)


@cocotb.test()
async def game_logic_test(dut):
    print("============== STARTING TEST ==============")
    # Initialize a 2D array with 6 rows and 7 columns
    array_2d = [[0 for _ in range(7)] for _ in range(6)]

    # Run the clock
    #Creates a 25MHz clock
    print("Starting clock")
    cocotb.start_soon(Clock(dut.clock, 40, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clock)

    # Reset the DUT
    print("Reseting")
    dut.reset.value = True
    await FallingEdge(dut.clock)
    await FallingEdge(dut.clock)
    dut.reset.value = False
    print("Reset Complete")

    print("Setting to PVP")
    await FallingEdge(dut.clock)
    dut.inputSwitchPVP.value = 1

    tokensArray = dut.tokens.value
    print("Tokens Array",tokensArray)

    # Fill the array using the value
    for i in range(6):
        for j in range(7):
            # Calculate the index in the value string corresponding to the current cell
            index = (i * 7 + j)*2
            # Assign the value from the string to the current cell
            array_2d[i][j] = int(tokensArray[index:index+1])


    print("Printing array after filling")
    # Print the array to see its content
    for row in array_2d:
        print(row)
    #Fill first coloum with player 1
    for i in range(6):
      dut.inputSwitchPlayer.value = 0
      #make move in row 1
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 1
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 1)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 1)
      assert (dut.owner.player_1_input.value == 1)
      assert (dut.owner.currentPlayer.value == 0)
      assert (dut.owner.move.value == 0)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 1)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #Fill second coloum with player 2
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 1
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 2
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 2)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 2)
      assert (dut.owner.player_2_input.value == 2)
      assert (dut.owner.currentPlayer.value == 1)
      assert (dut.owner.move.value == 1)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 2)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #Fill third coloum with player 1
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 0
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 4
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 4)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 4)
      assert (dut.owner.player_1_input.value == 4)
      assert (dut.owner.currentPlayer.value == 0)
      assert (dut.owner.move.value == 2)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 1)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #Fill fourth coloum with player 2
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 1
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 8
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 8)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 8)
      assert (dut.owner.player_2_input.value == 8)
      assert (dut.owner.currentPlayer.value == 1)
      assert (dut.owner.move.value == 3)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 2)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #Fill fifth coloum with player 1
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 0
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 16
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 16)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 16)
      assert (dut.owner.player_1_input.value == 16)
      assert (dut.owner.currentPlayer.value == 0)
      assert (dut.owner.move.value == 4)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 1)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #Fill sixth coloum with player 2
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 1
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 32
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 32)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 32)
      assert (dut.owner.player_2_input.value == 32)
      assert (dut.owner.currentPlayer.value == 1)
      assert (dut.owner.move.value == 5)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 2)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)


    #Fill seventh coloum with player 1
    for i in range(6):
      #make move in row 1
      dut.inputSwitchPlayer.value = 0
      await FallingEdge(dut.clock)
      print("Making "+str(i)+" move in row 1")
      dut.inputMoves.value = 64
      dut.inputConfirm.value = 1

      #Goes through first sync DFF
      await FallingEdge(dut.clock)
      #turns off confirm
      dut.inputConfirm.value = 0
      assert (dut.inputMovesHalf.value == 64)
      #Goes through second sync DFF
      #and goes through logic to change next clocks tokens
      await FallingEdge(dut.clock)
      assert (dut.inputMovesSync.value == 64)
      assert (dut.owner.player_1_input.value == 64)
      assert (dut.owner.currentPlayer.value == 0)
      assert (dut.owner.move.value == 6)
      await FallingEdge(dut.clock)
      assert (dut.owner.set.value == 1)
      #assert (dut.owner.tokensIn.value != 0)
      #tokens is changed
      await FallingEdge(dut.clock)
      assert (dut.tokens.value != 0)

      print("Getting array State")
      tokensArray = dut.tokens.value
      print("Tokens Array",tokensArray)

      # Fill the array using the value
      for i in range(6):
          for j in range(7):
              # Calculate the index in the value string corresponding to the current cell
              index = (i * 7 + j) *2
              #print("Index?: ",index)
              # Assign the value from the string to the current cell
              array_2d[i][j] = int(tokensArray[index:index+1])
      print("Printing array after filling")
      # Print the array to see its content
      for row in array_2d:
          print(row)

    #check array now that it is full
    print("Checking array now that it is full")
    for i in range(6):
        for j in range(7):
            if(j%2!=0):
                assert(array_2d[i][j] == 2)
            else:
                assert(array_2d[i][j] == 1)



#Requires that the instatination of VGA in top is commented out
@cocotb.test()
async def displayTest(dut):
    print("============== STARTING TEST ==============")

    #load in correct render of board/tokens
    correctImage = Image.open('correctBoardTokenRegions.png')

    #Defines the deminations for the render of the screen
    width, height = 640, 480
    cell_size = 1
    image = Image.new("RGB", (width,height), color ="white")
    draw = ImageDraw.Draw(image)

    
    # Initialize a 2D array with 6 rows and 7 columns
    array_2d = [[0 for _ in range(480)] for _ in range(640)]

    # Run the clock
    #Creates a 25MHz clock
    print("Starting clock")
    cocotb.start_soon(Clock(dut.clock, 40, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clock)

    # Reset the DUT
    print("Reseting")
    dut.reset.value = True
    await FallingEdge(dut.clock)
    await FallingEdge(dut.clock)
    dut.reset.value = False
    print("Reset Complete")

    #set is_player_1 high since we are jsut testing to see if the bounds
    #are set correctly
    dut.colors.is_player_1.value = Force(1)
    print("Filling Array")
    # Fill the array using the value
    for i in range(640):
        for j in range(480):
            await FallingEdge(dut.clock)
            dut.rowToModule.value = Force(j)
            dut.colToModule.value = Force(i)
            await RisingEdge(dut.clock)
            assert (dut.rowToModule.value == j)
            assert (dut.colToModule.value == i)
            # Determine what the current pixel should be displaying
            assert(dut.is_token.value != dut.is_board.value)
            if (dut.is_token.value == True):
              array_2d[i][j] = 'T'
              draw.rectangle([(i,j),(i+cell_size,j+cell_size)],fill="red")
            elif(dut.is_board.value == True):
              array_2d[i][j] = 'B'
              draw.rectangle([(i,j),(i+cell_size,j+cell_size)],fill="blue")
            else:
              array_2d[i][j] = 'X'
              draw.rectangle([(i,j),(i+cell_size,j+cell_size)],fill="green")
              print("Problem at i: ",i," j: ",j)
              #We shouldnt get here and if we do fail the cocoTB test
              assert(1==0)
            dut.rowToModule.value = Release()
            dut.colToModule.value = Release()
    

    differenceBetweeenImages = ImageChops.difference(image,correctImage)
    #If the images are the same then there is no differences and the correct
    #regions of board and tokens were output
    assert(differenceBetweeenImages.getbbox() == None)

    #release is_player_1 since test is complete
    dut.colors.is_player_1.value = Release()