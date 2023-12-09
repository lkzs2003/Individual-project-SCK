# Projekt Modułu `sync_arith_unit_29`

## Cel Projektu

Celem tego projektu jest implementacja synchronicznej jednostki arytmetyczno-logicznej `sync_arith_unit_29`. Jednostka ta realizuje operacje arytmetyczne, logiczne i inne na liczbach całkowitych zapisanych w kodzie Znak-Moduł (ZM). Projekt został wykonany na semestr 2023Z.

## Skład Projektu

Projekt składa się z następujących komponentów:

- **Model Układu Cyfrowego**: Opisany za pomocą języka opisu sprzętu SystemVerilog.
- **Synteza Układu Cyfrowego**: Wykorzystanie narzędzia open-source Yosys do syntezy układu.
- **Moduły Testowe (`testbench`)**: Do weryfikacji poprawności działania zaimplementowanego modelu oraz weryfikacji układu po syntezie.
- **Specyfikacja Zaprojektowanego Modelu**: Zawierająca raporty z wynikami działania przed i po syntezie oraz dane statystyczne dotyczące syntezy.

## Operacje Realizowane przez Układ

Moduł `sync_arith_unit_29` został zaprojektowany do realizacji następujących operacji na dwóch m-bitowych wektorach wejściowych A i B:

1. **A<~B**: Przesunięcie wektora A o ~B bitów w prawo.
2. **AS~B**: Sprawdzenie, czy liczba A jest mniejsza bądź równa zaprzeczonej liczbie B.
3. **A/B**: Dzielenie liczby A przez ~B.
4. **ZM(A) => U2(A)**: Zamiana liczby A z kodu znak-moduł na kod U2.

## Porty Układu

Układ posiada określone porty wejściowe i wyjściowe:

- `iop`: n-bitowe wejście określające kod operacji.
- `iarg_A`: m-bitowe wejście argumentu A.
- `iarg_B`: m-bitowe wejście argumentu B.
- `clk`: wejście zegarowe układu.
- `i_reset`: wejście resetu synchronicznego wyzwalanego stanem niskim.
- `o_result`: wyjście synchroniczne z układu.
- `o_status`: 4-bitowe wyjście synchroniczne informujące o statusie operacji.

## Statusy Operacji

Status operacji jest sygnalizowany przez bity w `o_status`:

- `ERROR`: Sygnalizacja niepoprawnego wyniku operacji.
- `NOT EVEN_1`: Sygnalizuje nieparzystą liczbę jedynek w wyniku.
- `ZEROS`: Sygnalizuje, że wszystkie bity wyniku są na 0.
- `OVERFLOW`: Sygnalizuje przepelnienie wyniku operacji.

## Instrukcje Uruchomienia i Testowania

[Dodaj instrukcje uruchamiania modułu, w tym jak skompilować i uruchomić testy.]

## Licencja

[Informacje o licencji (jeśli dotyczy).]

## Autor

[Dane autora projektu.]

---

Ten szkic jest bazowy i może być modyfikowany oraz uzupełniany zależnie od specyfiki projektu i dodatkowych wymagań.