%lang starknet

# Getting pointer as function arguments let us modify the values at the memory address of the pointer
# ...or not! Cairo memory is immutable. Therefore you cannot just update a memory cell.

# to make it achieve the desired result: returning an array
# with the squared values of the input array.

from starkware.cairo.common.alloc import alloc

func square(array : felt*, array_len : felt, squaredArray : felt*):
    if array_len == 0:
        return ()
    end

    let squared_item = array[0] * array[0]
    assert [squaredArray] = squared_item

    return square(array + 1, array_len - 1, squaredArray + 1)
end

# You can update the test if the function signature changes.
@external
func test_square{syscall_ptr : felt*}():
    alloc_locals
    let (local array : felt*) = alloc()

    assert [array] = 1
    assert [array + 1] = 2
    assert [array + 2] = 3
    assert [array + 3] = 4

    let (local squaredArray : felt*) = alloc()
    square(array, 4, squaredArray)

    assert [squaredArray] = 1
    assert [squaredArray + 1] = 4
    assert [squaredArray + 2] = 9
    assert [squaredArray + 3] = 16

    return ()
end
