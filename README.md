# EECFA
Sound art work "Exercício para erguer o corpo para fora d'água", created with processing and pure data.

LICENSED UNDER THE GNU GENERAL PURPOSE LICENSE.

exercício de erguer o corpo para fora d’água” foi elaborada a partir da ideia de simular um ecossistema simples com um algoritmo genético e indivíduos autônomos.
O desenvolvimento do projeto foi feito através do Processing 3, e paralelamente foi sonificado por meio de uma conexão por Protocolo OSC com Pure Data. 
Para tanto, foi utilizada a biblioteca oscP5 de Andreas Schlegel no Processing, 
e a biblioteca ELSE – de Alexandre Porres - e mrpeach – de Martin Peach - no Pure Data. 
O trabalho divide entre os Softwares seu aspecto gráfico e sonoro. 
No Processing, é feita simulação de uma população sexuada, capaz de se reproduzir, mutar seu material genético, mover-se pelo espaço bidimensional de forma randômica ou direcionada ao alimento mais próximo. 
Os “alelos” dos objetos criados são enviados via OSC para um patch de Pure Data, que posiciona cada indivíduo em seu espaço sonoro “falando” uma gravação. 
Essa gravação é processada e mixada com barulhos que simulam generativamente processos naturais como ondas e vento. 
O trabalho tem seu término quando a população não é capaz de se sustentar e o último indivíduo de sua espécie desaparece.

Author: Arthur Murtinho
version: 0.01
