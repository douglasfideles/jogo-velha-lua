function criaTabuleiro(n)
    return {{n, n,n}, {n,n, n},{n, n,n} }
end

function pulaLinha(n)
    for i = 0, n do print() end
end

function checaSO()

    home = os.getenv("HOME")
    if home == nil then return "|", "--", " " end
    return "↓", "→", "."

end

function aberturaJogo()

    pulaLinha(5)
    print("\t=-=-=-=-=-=-=-=-=-=-=-=-=-=")
    print("\t=      JOGO DA VELHA      =")
    print("\t=-=-=-=-=-=-=-=-=-=-=-=-=-=")

end

function recebeNomes()

    jogs = {}
    for i = 1, 2 do
        msg = "Digite o nome do jogador numero %s: "
        io.write(msg:format(i))
        table.insert(jogs, io.read())
    
    end
    return jogs

end

function imprimirTabuleiro(T, SB, SD)

    aberturaJogo()
    pulaLinha(2)
    print(string.format("\t\t    A B C\n\t\t    %s %s %s", SB, SB, SB))
    for i = 1, 3 do
        io.write(string.format("\t\t %s%s", i, SD))
        print(table.concat(T[i], " "))

    end
    pulaLinha(5)

end

function lerJogada(JOGADORES, X)

    jogada = {}
    checaJogada = function(jog)

        coluna = string.byte(jog:upper()) - 64
        linha = tonumber(jog:sub(2, 2))
        if coluna >= 1 and coluna <= 3 and linha >= 1 and linha <= 3 then
            return coluna, linha
        else
            print("Sua jogada foi invalida! Jogue novamente")
            lerJogada(JOGADORES, X)
        end

    end

    io.write(string.format("%s, digite sua jogada (Ex: B3, A1, C2): ", JOGADORES[X]))
    return checaJogada(io.read())

end

function preencheTabuleiro(tabuleiro, POS_VAZIA, PECAS, jogadores, i, COL, LIN)
    
    if tabuleiro[LIN][COL] == POS_VAZIA then

        tabuleiro[LIN][COL] = PECAS

    else

        msg = "%s, Voce tentou um posicao ja preenchida. Jogue novamente!"
        print(msg:format(jogadores[i]))
        preencheTabuleiro(tabuleiro, POS_VAZIA, PECAS, jogadores, i, lerJogada(jogadores, i))
    
    end

    return tabuleiro

end

function checaTabuleiro(PECAS, TABULEIRO, JOGADORES, POS_VAZIA)

    vitoria = false
    vitorioso = ''
    contDiagonais = 0

    for i, PECA in ipairs(PECAS) do
        for j =1, 3 do

            if TABULEIRO[j][1] == PECA and TABULEIRO[j][2] == PECA and TABULEIRO[j][3] == PECA then
                vitoria = true
                vitorioso = JOGADORES[i]
                break
            end
            if TABULEIRO[1][j] == PECA and TABULEIRO[2][j] == PECA and TABULEIRO[3][j] == PECA then
                vitoria = true
                vitorioso = JOGADORES[i]
                break
            end

        end

        if TABULEIRO[1][1] == PECA and TABULEIRO[2][2] == PECA and TABULEIRO[3][3] then
            
            vitoria = true
            vitorioso = JOGADORES[i]
            break
        elseif TABULEIRO[1][3] == PECA and TABULEIRO[2][2] == PECA and TABULEIRO[3][1] then
            
            vitoria = true
            vitorioso = JOGADORES[i]
            break

        end
    
    end

    return vitoria, vitorioso

end

function checaVelha(TABULEIRO, POS_VAZIA)
    contador = 0
    for i in ipairs(TABULEIRO) do
        for j in ipairs(TABULEIRO[i]) do

            if TABULEIRO[i][j] == POS_VAZIA then
                contador = contador + 1
            end
        end
    end
    if contador > 0 then return false end
    return true
end

aberturaJogo()
SETA_BAIXO, SETA_DIREITA, POS_VAZIA = checaSO()
tabuleiro = criaTabuleiro(POS_VAZIA)
jogadores = recebeNomes()
PECAS = {"x","0"}

imprimirTabuleiro(tabuleiro, SETA_BAIXO, SETA_DIREITA)

repeat

    while true do
        for i in pairs(jogadores) do

            imprimirTabuleiro(tabuleiro, SETA_BAIXO, SETA_DIREITA)
            tabuleiro = preencheTabuleiro(tabuleiro, POS_VAZIA, PECAS[i], jogadores, i, lerJogada(jogadores, i))
            vitoria, vitorioso =  checaTabuleiro(PECAS, tabuleiro, jogadores, POS_VAZIA)
            vellha = checaVelha(tabuleiro , POS_VAZIA)
            if vellha then break end
            if vitoria then break end
        end
        if vellha then

            print("Que pena!Ninguem ganhou :(")
            break
        end
        if vitoria then 

            msgVitoria = "PARABENS %s! Voce ganhou :) "
            print(msg:format(vitorioso:upper()))
            break

        end
    end
    pulaLinha(2)
    print("Obrigado por jogar!\n Deseja jogar novamente? (S/N)")
    jogaNovamente = io.read()
    if jogaNovamente:upper() == "S" then 
        
        jogaNovamente = true
    
    else

        jogaNovamente = false
        
    end
    
    tabuleiro = criaTabuleiro(POS_VAZIA)

until not jogaNovamente

