grammar SqlParse;

sql_script
    : statement+ EOF
    ;

statement
    : insertStatement SEMICOLON?
    ;

insertStatement
    : INSERT INTO tableName partitionClause? selectStatement
    ;

partitionClause
    : PARTITION LPAREN partitionSpecList RPAREN
    ;

partitionSpecList
    : partitionSpec (COMMA partitionSpec)*
    ;

partitionSpec
    : identifier (EQUAL expression)?
    ;

selectStatement
    : SELECT selectElements fromClause whereClause? groupByClause? havingClause? orderByClause? limitClause?
    ;

selectElements
    : selectElement (COMMA selectElement)*
    ;

selectElement
    : expression alias?
    ;

alias
    : AS? identifier
    ;

fromClause
    : FROM relation (COMMA relation)*
    ;

relation
    : tableName alias?
    ;

tableName
    : identifier (DOT identifier)*
    ;

whereClause
    : WHERE expression
    ;

groupByClause
    : GROUP BY groupByItem (COMMA groupByItem)*
    ;

groupByItem
    : expression
    ;

havingClause
    : HAVING expression
    ;

orderByClause
    : ORDER BY orderByItem (COMMA orderByItem)*
    ;

orderByItem
    : expression (ASC | DESC)?
    ;

limitClause
    : LIMIT expression (COMMA expression)?
    ;

expression
    : logicalOrExpression
    ;

logicalOrExpression
    : logicalAndExpression (OR logicalAndExpression)*
    ;

logicalAndExpression
    : logicalNotExpression (AND logicalNotExpression)*
    ;

logicalNotExpression
    : NOT logicalNotExpression
    | comparisonExpression
    ;

comparisonExpression
    : predicateExpression ((EQUAL | NOTEQUAL | NOTEQUAL2 | LT | LTE | GT | GTE) predicateExpression)?
    | predicateExpression (IS NOT? NULL)
    | predicateExpression (NOT? (LIKE | RLIKE | REGEXP) predicateExpression)
    ;

predicateExpression
    : valueExpression
    ;

valueExpression
    : additiveExpression
    ;

additiveExpression
    : multiplicativeExpression ((PLUS | MINUS) multiplicativeExpression)*
    ;

multiplicativeExpression
    : unaryExpression ((STAR | DIVIDE | MODULO) unaryExpression)*
    ;

unaryExpression
    : (PLUS | MINUS) unaryExpression
    | primaryExpression
    ;

primaryExpression
    : literal
    | columnName
    | functionCall
    | castExpression
    | caseExpression
    | LPAREN expression RPAREN
    ;

caseExpression
    : CASE expression? whenClause+ elseClause? END
    ;

whenClause
    : WHEN expression THEN expression
    ;

elseClause
    : ELSE expression
    ;

castExpression
    : CAST LPAREN expression AS dataType RPAREN
    ;

dataType
    : identifier (identifier)*
    ;

functionCall
    : identifier LPAREN (expression (COMMA expression)*)? RPAREN
    ;

columnName
    : identifier (DOT identifier)*
    ;

literal
    : STRING_LITERAL
    | NUMBER
    | NULL
    ;

identifier
    : ID
    ;

INSERT: I N S E R T;
INTO: I N T O;
PARTITION: P A R T I T I O N;
SELECT: S E L E C T;
FROM: F R O M;
WHERE: W H E R E;
GROUP: G R O U P;
BY: B Y;
HAVING: H A V I N G;
ORDER: O R D E R;
LIMIT: L I M I T;
ASC: A S C;
DESC: D E S C;
AS: A S;
CASE: C A S E;
WHEN: W H E N;
THEN: T H E N;
ELSE: E L S E;
END: E N D;
CAST: C A S T;
IS: I S;
NOT: N O T;
NULL: N U L L;
OR: O R;
AND: A N D;
LIKE: L I K E;
RLIKE: R L I K E;
REGEXP: R E G E X P;

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
DOT: '.';
SEMICOLON: ';';
PLUS: '+';
MINUS: '-';
STAR: '*';
DIVIDE: '/';
MODULO: '%';
EQUAL: '=';
LTE: '<=';
LT: '<';
GTE: '>=';
GT: '>';
NOTEQUAL: '!=';
NOTEQUAL2: '<>';

STRING_LITERAL
    : '\'' ( '\'' '\'' | ~('\'' | '\\') | '\\' . )* '\''
    ;

NUMBER
    : DIGIT+ (DOT DIGIT+)?
    ;

ID
    : (LETTER | DIGIT | '_' | '{' | '}') (LETTER | DIGIT | '_' | '{' | '}')*
    ;

fragment LETTER
    : [A-Za-z_]
    ;

fragment DIGIT
    : [0-9]
    ;

fragment A: [aA];
fragment B: [bB];
fragment C: [cC];
fragment D: [dD];
fragment E: [eE];
fragment F: [fF];
fragment G: [gG];
fragment H: [hH];
fragment I: [iI];
fragment J: [jJ];
fragment K: [kK];
fragment L: [lL];
fragment M: [mM];
fragment N: [nN];
fragment O: [oO];
fragment P: [pP];
fragment Q: [qQ];
fragment R: [rR];
fragment S: [sS];
fragment T: [tT];
fragment U: [uU];
fragment V: [vV];
fragment W: [wW];
fragment X: [xX];
fragment Y: [yY];
fragment Z: [zZ];

COMMENT
    : '--' ~[\r\n]* -> skip
    ;

MULTILINE_COMMENT
    : '/*' .*? '*/' -> skip
    ;

WS
    : [ \t\r\n]+ -> skip
    ;
