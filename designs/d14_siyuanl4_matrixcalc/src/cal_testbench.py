import os
import logging
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import *
import numpy as np
import random


async def check_multiply_golden(matrix_ab, matrix_c):
    matrix_a = np.array(matrix_ab[:16]).reshape(4, 4)
    matrix_b = np.array(matrix_ab[16:]).reshape(4, 4)
    expected_result = np.dot(matrix_a, matrix_b)
    expected_result = expected_result.flatten().tolist()
    
    if matrix_c == expected_result:
        return True
    else:
        return False

async def check_add_golden(matrix_ab, matrix_c):
    matrix_a = np.array(matrix_ab[:16]).reshape(4, 4)
    matrix_b = np.array(matrix_ab[16:]).reshape(4, 4)
    expected_result = matrix_a + matrix_b
    expected_result = expected_result.flatten().tolist()
    
    if matrix_c == expected_result:
        return True
    else:
        return False

async def check_subtract_golden(matrix_ab, matrix_c):
    matrix_a = np.array(matrix_ab[:16], dtype=np.uint16).reshape(4, 4)
    matrix_b = np.array(matrix_ab[16:], dtype=np.uint16).reshape(4, 4)   
    expected_result = (matrix_a - matrix_b) % 32
    expected_result = expected_result.flatten().tolist()
    
    if matrix_c == expected_result:
        return True
    else:
        return False

async def enter_pulse(dut):
    dut.enter.value = True
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.enter.value = False
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

async def switch_pulse(dut):
    dut.sw.value = True
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.sw.value = False
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

async def random_matrix():
    # Create a list of 32 elements, each element being a 4-bit integer
    matrix_list = [random.randint(0, 15) for _ in range(32)]
    return matrix_list

# input the matrix into the DUT
# matrix_list is a list of 4-bit numbers
# the total number of elements in the list is 32
async def matrix_in(dut, matrix_list):
    # create new list to store actual input
    combined_list = []
    for i in range(0, len(matrix_list), 2):
        combined_num = (matrix_list[i] << 4) | matrix_list[i+1]
        combined_list.append(combined_num)
    
    for i in combined_list:
        dut.data_in.value = i
        await enter_pulse(dut)

# read the output matrix from the DUT
# the output matrix is a list of 10-bit numbers
# the total number of elements in the list is 16
async def matrix_out(dut):
    raw_list = []
    for i in range(0, 32, 1):
        raw_list.append(int(dut.data_out.value))
        await switch_pulse(dut)

    matrix_list = []
    for i in range(0, len(raw_list), 2):
        first_half = raw_list[i] << 5
        second_half = raw_list[i+1]
        combined_num = first_half | second_half
        matrix_list.append(combined_num)
    return matrix_list
    


async def mult_test(dut):
    print("============== STARTING Multiply TEST ==============")

    # Run the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clk)

    # Reset the DUT
    dut.rst.value = True
    dut.sw.value = False
    dut.enter.value = False

    # multi
    dut.operation.value = 0

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst.value = False

    await FallingEdge(dut.clk)

    matrix_ab = await random_matrix()
    await matrix_in(dut, matrix_ab)

    assert dut.finish.value == 0
    assert dut.error.value == 0

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

    assert dut.finish.value == 1
    assert dut.error.value == 0

    matrix_c = await matrix_out(dut)

    check=await check_multiply_golden(matrix_ab, matrix_c)
    assert check == True


async def add_test(dut):
    print("============== STARTING Add TEST ==============")

    # Run the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clk)

    # Reset the DUT
    dut.rst.value = True
    dut.sw.value = False
    dut.enter.value = False

    # add
    dut.operation.value = 2

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst.value = False

    await FallingEdge(dut.clk)

    matrix_ab = await random_matrix()
    await matrix_in(dut, matrix_ab)

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

    assert dut.finish.value == 1
    assert dut.error.value == 0

    matrix_c = await matrix_out(dut)

    check=await check_add_golden(matrix_ab, matrix_c)
    assert check == True


async def sub_test(dut):
    print("============== STARTING Subtract TEST ==============")

    # Run the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clk)

    # Reset the DUT
    dut.rst.value = True
    dut.sw.value = False
    dut.enter.value = False

    # add
    dut.operation.value = 3

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst.value = False

    await FallingEdge(dut.clk)

    matrix_ab = await random_matrix()
    await matrix_in(dut, matrix_ab)

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

    assert dut.finish.value == 1
    assert dut.error.value == 0

    matrix_c = await matrix_out(dut)

    check=await check_subtract_golden(matrix_ab, matrix_c)
    assert check == True



async def error_test(dut):
    print("============== STARTING Error TEST ==============")

    # Run the clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Since our circuit is on the rising edge,
    # we can feed inputs on the falling edge
    # This makes things easier to read and visualize
    await FallingEdge(dut.clk)

    # Reset the DUT
    dut.rst.value = True
    dut.sw.value = False
    dut.enter.value = False

    # invalid op
    dut.operation.value = 1

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)
    dut.rst.value = False

    await FallingEdge(dut.clk)

    matrix_ab = await random_matrix()
    await matrix_in(dut, matrix_ab)

    assert dut.finish.value == 0
    assert dut.error.value == 1

    await FallingEdge(dut.clk)
    await FallingEdge(dut.clk)

    assert dut.finish.value == 0
    assert dut.error.value == 1


@cocotb.test()
async def test_constrained_random(dut):
    random.seed(42)
    # NUM_TEST_CASES = random.randint(1, 100)
    NUM_TEST_CASES = 10


    for _ in range(NUM_TEST_CASES):
        await mult_test(dut)
        await add_test(dut)
        await sub_test(dut)
        await error_test(dut)