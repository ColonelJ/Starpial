?> Prolog example <?
?>
   witch(X)  <= burns(X) and female(X).

   burns(X)  <= wooden(X).

   wooden(X) <= floats(X).
   wooden(woodBridge).
   stone(stoneBridge).

   floats(bread).
   floats(apple).
   floats(cherry).
   floats(X) <= sameweight(duck, X).

   female(girl).          {by observation}
   sameweight(duck,girl). {by experiment }

   ? witch(girl).

   { After Monty Python (Sir Bedevere). }
<?

@witch:#X cat{X burns "; " X female " too, therefore " X " is a witch!! BURN!!!!"}

@burns:#X cat{X wooden " so " X " burns"}

@wooden:#X cat{X floats " meaning " X " is wooden"}
@wooden:#"woodBridge" "woodBridge is wooden"
@stone:#"stoneBridge" "stoneBridge is made of stone"

@floats:#"bread" "bread floats"
@floats:#"apple" "apples float"
@floats:#"cherry" "cherries float"
@floats:#X cat{"duck" sameweight(X) " so " X " floats"}
@female:#"girl" "girls are female"
@sameweight:#"duck" #"girl" "girl is the same weight as a duck"

["girl" witch]`["No, girl is not witch..."]# print
?\girl is the same weight as a duck so girl floats meaning girl is wooden so girl burns; girls are female too therefore girl is a witch!! BURN!!!!
