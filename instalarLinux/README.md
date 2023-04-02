#Guia passo a passo de como instalar o Oracle Linux no VirtualBox

##Siga as instruções passo a passo abaixo para instalar o Oracle Linux versão 8.7 no VirtualBox, com uma alocação de espaço em disco de 30GB, 2GB de RAM, 1 núcleo de processador e uma configuração de adaptador de ponte sem GUI:

###Download da Imagem
Baixe a imagem ISO do Oracle Linux neste link: `https://www.oracle.com/linux/technologies/oracle-linux-downloads.html`

### Criando sua Máquina Virtual

> Caso não tenha o virtual box instalado, faça o download por aqui: https://www.virtualbox.org/wiki/Downloads

1. Abra o VirtualBox e clique em "Novo" para criar uma nova máquina virtual.
2. Nomeie a máquina virtual como "Oracle Linux" e selecione "Linux" como tipo e "Oracle (64-bit)" como versão.
3. Defina o tamanho da memória para 2048 MB e clique em "Avançar".
4. Escolha "Criar um disco rígido virtual agora" e clique em "Criar".
5. Escolha "VDI" como tipo de arquivo de disco rígido e clique em "Avançar".
6. Escolha "Alocação dinâmica" como armazenamento no disco rígido físico e clique em "Avançar".
7. Defina o tamanho do disco rígido virtual para 30GB e clique em "Criar".
8. Clique na máquina virtual recém-criada "Oracle Linux" e clique em "Configurações".
9. Clique na guia "Armazenamento", em seguida, clique no ícone de CD "Vazio" sob a seção "Controlador: IDE".
10. Clique no botão "Escolher arquivo de imagem óptica virtual" e navegue até a imagem ISO do Oracle Linux baixada.
11. Clique em "OK" para fechar a janela de configurações.

### Instalando o Oracle Linux na sua Máquina Virtual
 
1. Inicie a máquina virtual "Oracle Linux".
2. No menu de inicialização, selecione "Instalar o Oracle Linux 8.x" e pressione Enter.
3. Selecione seu idioma preferido e clique em "Continuar".
4. Defina seu fuso horário e data e hora, em seguida, clique em "Concluído".
5. Clique na opção "Destino de instalação".
6. Selecione o disco rígido virtual que criamos anteriormente e clique em "Concluído".
7. Clique em "Rede e Nome do host" e habilite a conexão Ethernet. Clique em "Configurar" ao lado do cartão "Ethernet".Escolha "IPv4" e clique em "Concluído".Escolha "Automático (DHCP)" e clique em "Salvar".
8. Desative "KDUMP" clicando no botão ao lado.
9. Clique na opção "Seleção de software".
10. Selecione a opção "Instalação mínima" e clique em "Concluído".
11. Clique em "Iniciar instalação".
12. Quando a instalação estiver concluída, clique em "Reiniciar". Após reiniciar, faça login no console.

### Seus primeiros comandos no Linux
1. Abra o terminal e digite o seguinte comando para configurar a interface de rede:
`
sudo nmcli connection modify <interface-name> bridge.br0
sudo nmcli connection up <interface-name>
`
> (Substitua "<interface-name>" pelo nome de sua interface Ethernet)

Para configurar o adaptador bridge, abra o arquivo de configuração de rede:
`sudo vi /etc/sysconfig/network-scripts/ifcfg-<interface-name>`
> (Substitua "<interface-name>" pelo nome de sua interface Ethernet)
Adicione as seguintes linhas ao final do arquivo para configurar a interface de ponte:
`
  BRIDGE=br0
  NM_CONTROLLED="no"
`
Salve e saia do arquivo.
> `:` `wq` `Enter`
Em seguida, configure o arquivo de configuração do adaptador de ponte:
  `sudo vi /etc/sysconfig/network-scripts/ifcfg-br0`

Adicione as seguintes linhas ao final do arquivo para configurar a ponte:
`DEVICE=br0
TYPE=Bridge
BOOTPROTO=dhcp
ONBOOT=yes`

Salve e saia do arquivo.
> `:` `wq` `Enter`
Reinicie a interface de rede com o seguinte comando:

`sudo systemctl restart NetworkManager`

Seu Oracle Linux agora está instalado no VirtualBox com um adaptador de ponte configurado. Parabéns!
