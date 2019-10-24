# o1
function usegreed(coins)
    val = true
    for i in 1:length(coins)-1
        val = val && coins[i] % coins[i+1] == 0 # Checks previous answer and if it's still true that it's a multiplum
    end
    return val
end

# printstyled("\n\n\n---------------\nKjører tester\n---------------\n"; color = :magenta)

# using Test
# @testset "Tester" begin
#     @test usegreed([20, 10, 5, 1]) == true
#     @test usegreed([20, 15, 10, 5, 1]) == false
#     @test usegreed([100, 1]) == true
#     @test usegreed([5, 4, 3, 2, 1]) == false
#     @test usegreed([1]) == true

# end




# o2
# Always remove the value of the largest coin possible
# The way I've done it just removes the value of several coins of a certain size at the same time
function mincoinsgreedy(coins, value)
    totalCoins = 0
    for i in 1:length(coins)
        totalCoins += trunc(Int, coins[i] \ value) # 5 \ 35     # => 7.0
        value = value % coins[i]
    end
    return totalCoins
end

# printstyled("\n\n\n---------------\nKjører tester\n---------------\n"; color = :magenta)

# using Test
# @testset "Tester" begin
# 	@test mincoinsgreedy([1000,500,100,20,5,1],1226) == 6
#     @test mincoinsgreedy([20,10,5,1],99) == 10
#     @test mincoinsgreedy([5,1],133) == 29
# end





# o3
# Think stave cutting
# Value is the lenght of the stave, every lenght has the same price per unit of length
# Cutting the stave costs money, so you want to do it as few times as possible while still sell the whole length
# coins is the array of possible lengths you can vut
# Feel free to change the variable names in your own code if it makes visualizing it easier
function mincoins(coins, value, vArray = []) #vArray[value] = min # of coins to get the value
    inf = typemax(Int)/1000
    if(vArray == [])
        vArray = fill(inf, value)
    end
    if usegreed(coins) return mincoinsgreedy(coins, value) end # Because I can

    # Base cases
    if(in(value, coins))
        return 1
    end
    if(value<coins[end]) return inf end

    # Else try all other options
    A = zeros(Int64, length(coins))
    for c in coins
        if(value - c <= 0)
            continue
        end
        if(vArray[value - c] == inf)
            vArray[value - c] = mincoins(coins, value - c, vArray)
        end

        if(vArray[value] > 1+vArray[value - c])
            vArray[value] = 1+vArray[value - c]
        end
    end
    return vArray[value]
end

printstyled("\n\n\n---------------\nKjører tester\n---------------\n"; color = :magenta)

using Test
@testset "Tester" begin
	@test mincoins([4,3,1],18) == 5
    @test mincoins([1000,500,100,30,7,1],14) == 2
    @test mincoins([40, 30, 20, 10, 1], 90) == 3
end
