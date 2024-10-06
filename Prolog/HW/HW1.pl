correctAnswer("jan-dynotis-tp-ecuador, feb-comati-fusor-france, mar-adtina-dd-qatar, apr-tamura-poly-zambia").

% Условие 1: Реактор, запущенный в марте - это либо DD реактор, либо реактор, построенный во Франции.
condition_1(Solution) :-
    (
        member(reactorInfo(mar, _, dd, Country), Solution),
        Country \= france
    );
    (
        member(reactorInfo(mar, _, Principle, france), Solution),
        Principle \= dd
    ).

% Условие 2: Реактор Comati DX5 был запущен НЕ в январе.
condition_2(Solution) :-
    member(reactorInfo(Month, comati, _, _), Solution), 
    Month \= jan.

% Условие 3: Реактор, запущенный в марте, TP реактор и реактор в Замбии - это три разных реактора.
condition_3(Solution) :-
    member(reactorInfo(mar, MarchReactor, _, _), Solution),
    member(reactorInfo(_, TPReactor, tp, _), Solution),
    member(reactorInfo(_, ZambiaReactor, _, zambia), Solution),
    MarchReactor \= TPReactor,
    MarchReactor \= ZambiaReactor,
    TPReactor \= ZambiaReactor.

% Условие 4: Реактор, запущенный в январе - это либо TP реактор, либо реактор из Катара.
condition_4(Solution) :-
    (
        member(reactorInfo(jan, _, tp, Country), Solution),
        Country \= qatar
    );
    (
        member(reactorInfo(jan, _, Principle, qatar), Solution),
        Principle \= tp
    ).

% Условие 5: Из двух реакторов, TP реактор и реактор, запущенный в феврале, один - это Comati DX5, а другой из Эквадора.
condition_5(Solution) :-
    (
        member(reactorInfo(feb, comati, Principle1, Country1), Solution),
        member(reactorInfo(Month1, Name1, tp, ecuador), Solution),
        Month1 \= feb,
        Name1 \= comati,
        Principle1 \= tp,
        Country1 \= ecuador
    );
    (
        member(reactorInfo(feb, Name2, Principle2, ecuador), Solution),
        member(reactorInfo(Month2, comati, tp, Country2), Solution),
        Month2 \= feb,
        Name2 \= comati,
        Principle2 \= tp,
        Country2 \= ecuador
    ).

% Условие 6: Реактор Tamura BX12 построен в Замбии.
condition_6(Solution) :-
    member(reactorInfo(_, tamura, _, zambia), Solution).

% Условие 7: Реактор, запущенный в апреле, Adtina V и fusor-реактор - это три разных реактора.
condition_7(Solution) :-
    member(reactorInfo(apr, AprilReactor, _, _), Solution),
    member(reactorInfo(_, adtina, _, _), Solution),
    member(reactorInfo(_, FusorReactor, fusor, _), Solution),
    AprilReactor \= adtina,
    AprilReactor \= FusorReactor,
    FusorReactor \= adtina.

% Условие 8: Реактор из Катара - это либо реактор, запущенный в марте, либо Dynotis X1.
condition_8(Solution) :- 
    (
        member(reactorInfo(Month, dynotis, _, qatar), Solution),
        Month \= mar
    );
    (
        member(reactorInfo(mar, Name, _, qatar), Solution),
        Name \= dynotis
    ).

% Основной предикат решения задачи
sol(S) :-
    % Создаём вмевозможные квартеты реакторов:
    Solution = [
        reactorInfo(jan, JanName, JanPrinciple, JanCountry),
        reactorInfo(feb, FebName, FebPrinciple, FebCountry),
        reactorInfo(mar, MarName, MarPrinciple, MarCountry),
        reactorInfo(apr, AprName, AprPrinciple, AprCountry)
    ],
    
    % Для вывода через дефис:
    S = [
        jan-JanName-JanPrinciple-JanCountry,
        feb-FebName-FebPrinciple-FebCountry,
        mar-MarName-MarPrinciple-MarCountry,
        apr-AprName-AprPrinciple-AprCountry
    ],

    % Всевозможные перестановки
    % Имён реакторов:
    permutation([dynotis, comati, adtina, tamura], [JanName, FebName, MarName, AprName]),
    % Принципов работы:
    permutation([tp, fusor, dd, poly], [JanPrinciple, FebPrinciple, MarPrinciple, AprPrinciple]),
    % Стран:
    permutation([qatar, ecuador, zambia, france], [JanCountry, FebCountry, MarCountry, AprCountry]),

    % Отбрасываем четвёрки реакторов, не подходящие под условия задачи:
    condition_1(Solution),  % March + DD / France
    condition_2(Solution),  % Comati + !January
    condition_3(Solution),  % March != TP != Zambia
    condition_4(Solution),  % Jan + TP / Qatar
    condition_5(Solution),  % (TP + Comati / Ecvador) AND (Feb + Ecvador / Comati)
    condition_6(Solution),  % Tamura + Zambia
    condition_7(Solution),  % April != Adtina != fusor
    condition_8(Solution).  % Qatar + March / Dynotis
