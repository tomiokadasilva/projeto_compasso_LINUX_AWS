# Projeto Estudo Compasso - Linux + AWS

Neste projeto, iremos abordar o provisionamento de instâncias EC2 na Amazon AWS através de linhas de comando. Também, iremos configurar um servidor Apache dentro de nossa instância e monitorá-lo de forma periódica utilizando o cron. Para o provisionamento de instâncias EC2, será disponibilizado um script. Adicionalmente, iremos montar um Network File System (NFS) utilizando o Amazon EFS (Elastic File System). E ao final, verificaremos a disponibilidade das portas na instância.

## Usando o Script de Provisionamento de Instancia EC2
Através do uso da AWS CLI é possível automatizar a criação da instância executando um script. 

Neste exemplo, o script provisiona uma instância com as seguintes características:
```
Amazon EC2 
Sistema Operacional: `Amazon Linux 2`
Região: `us-east-1` 
Familia: `t3.small`
Volume: `SSD 16GB`
```
Também, esse script irá alocar e anexar um IP elástico à instância, criar uma nova subnet, internet gateway e VPC.

Um novo grupo de segurança denominado também é criado e regras são adicionadas para autorizar o tráfego nas portas `22, 80, 443, 111/TCP e UDP e 2049/TCP e UDP`. Um novo par de chaves denominado também é criado para acesso à instância. Finalmente, tags são adicionadas à instância para identificar sua finalidade, centro de custo, projeto e tipo de recurso.

### Pre-requisitos.
* AWS CLI instalado e configurado com as credenciais apropriadas.
* Ambiente de shell Bash.
### Como usar
1. Clone ou faça o download do script para sua máquina local.
2. Abra um terminal e navegue até o diretório onde o script está localizado.
3. Torne o script executável executando chmod `+x ec2_provisioning.sh.`
4. Defina as variáveis de ambiente necessárias no script, como o Nome da VPC e a região, e modifique o script de acordo com suas necessidades.
5. Execute o script executando `./ec2_provisioning.sh.`
6. Aguarde o script ser concluído. Pode levar alguns minutos para a instância ser lançada e ficar disponível.
7. Depois que o script for concluído, você deverá ver o ID da instância e o endereço IP público impressos no console. Você pode usar essas informações para acessar a instância.

## Testando sua instância
Após a criação da instância, você pode testar se ela está disponível executando o script `ec2_instance_test.sh`. 

> NOTA: Esse script aceita dois argumentos, seu `INSTANCE_ID` e seu `PATH_TO_KEY_PAIR`

Para executar o script, primeiro você deve realizar o download do script para sua máquina local, torná-lo executável usando `chmod +x ec2_instance_test.sh` e depois executar o comandoScript `ec2_instance_test.sh.` para visualizar o teste em console

## Montando um NFS com AWS EFS
Para montar um sistema de arquivos NFS na sua instância EC2 AWS usando o EFS, siga os seguintes passos:

1. Acesse o Console de Gerenciamento da AWS e Selecione o serviço Amazon EFS.
2. Clique em `Criar sistema de arquivos` e Selecione as opções desejadas para configuração do EFS, incluindo a região da AWS onde será criado.
3. Clique em `Criar sistema de arquivos`

Para montar o sistema de arquivos EFS em um servidor NFS por IP, siga os seguintes passos:

1. Acesse a instância do servidor NFS por SSH.
2. Instale o pacote `amazon-efs-utils` executando o comando `sudo yum install amazon-efs-utils` (no Amazon Linux).
3. Crie o ponto de montagem executando o comando `sudo mkdir /mnt/efs`.
4. Monte o sistema de arquivos EFS executando o comando `sudo mount -t efs <ID_DO_FILE_SYSTEM>:/ /mnt/efs`, onde `<ID_DO_FILE_SYSTEM>` é o ID do sistema de arquivos EFS que você criou.
5. Verifique se o EFS foi montado corretamente executando o comando `df -h` e verificando se o ponto de montagem `/mnt/efs` está listado.

> DICA: É possível fazer o sistema de arquivos EFS montar automaticamente durante o boot do servidor NFS, para isso, siga os passos à seguir:
>1. Acesse a instância do servidor NFS por SSH.
>2. Abra o arquivo `/etc/fstab` para edição executando o comando `sudo nano /etc/fstab`.
>3. Adicione a seguinte linha no final do arquivo: `<ID_DO_FILE_SYSTEM>:/ /mnt/efs efs defaults,_netdev 0 0` e Substitua "<ID_DO_FILE_SYSTEM>" pelo ID do seu sistema de arquivos EFS.
>4. Salve as alterações e feche o arquivo "/etc/fstab".
>5. Execute o comando "sudo mount -a" para testar se o EFS foi montado corretamente.
>6. Reinicie o servidor NFS com `sudo reboot` para testar se o EFS será montado automaticamente durante o boot.
>7. Após esses passos, o sistema de arquivos EFS deverá ser montado automaticamente durante o boot do servidor NFS.

## Servidor Apache

1. Certifique-se de que o apache está instalado e executando no seu servidor `sudo systemctl status httpd`

> NOTA: Caso o Apache não esteja sendo executado, você pode rodar o comando `sudo systemctl start httpd`

Uma vez que o servidor Apache estiver sendo executado, você pode acessá-lo usando o endereço de IP ou Domínio do servidor, no seu Navegador web. Por exemplo, se o IP do seu servidor for 192.168.0.1 você digitaria `http://192.168.0.1`
Caso você não saiba seu endereço de IP Público você pode digitar no console `curl ifconfig.me`

2. Você irá executar o script `check_apache.sh`

> NOTA: Lembre-se de tornar o script executável utilizando o comando `chmod +x check_apache.sh`

## Usando o CRON para automatizar a execução do Script

Você pode acessar o arquivo de configuração do Cron através do comando `crontab -e`. E, dentro desse arquivo, você pode definir o tempo que você deseja que o script seja executado e o caminho do script

O formato que deve ser usado é o seguinte:
```
*     *     *     *     *  Comando a ser Executado
-     -     -     -     -
|     |     |     |     |
|     |     |     |     +----- Dia da Semana (0 - 6) (Domingo é 0)
|     |     |     +------- Mês (1 - 12)
|     |     +--------- Dia do Mês (1 - 31)
|     +----------- Hora (0 - 23)
+------------- Minuto (0 - 59)
```
Por exemplo, para a execução do script `check_apache.sh`:

`*/5 * * * * /home/user/check_apache.sh`

onde `*/5 * * * * /` define a execução do script para cada 5 minutos e `/home/user/check_apache.sh` define o caminho para a execução do seu script.


> NOTA: Lembre-se de dar ao CRON as permissões necessárias para acessar o arquivo que será executado. Por exemplo, caso o arquivo esteja dentro de um NFS montado.

## Certificando-se de que as portas 22, 80, 111, 443 e 2049 estão abertas
1. Certifique-se de que você possui o comando nmap instalado com o comando `nmap --version`
> Caso não tenha o nmap instalado, execute o comando `sudo yum install nmap` para realizar o download e instalação do pacote.

2. Realize o comando `nmap` no seu IP público. Por exemplo `nmap 192.168.0.1`
Este comando irá retornar as portas disponíveis no seu ip, o estado delas e o serviço que estão utilizando. Se tudo foi configurado corretamente, você deverá ver uma saída parecida com a abaixo:

```
Starting Nmap 6.40 ( http:nmap.org) at 2023-04-03 12:22 -03
Nmap scan report for ec2-IP-Público.compute-1.amazonaws.com (IP Público)
Host is up (0.00056s latency).
Not shown: 995 filtered ports
PORT      STATE SERVICE
22/TCP    open  ssh
80/TCP    open  http
111/TCP   open  rpcbind
443/TCP   open  https
2049/TCP  open  nfs

Nmap done: 1 IP address (1 host up) scanned in 4.65 seconds
```
> A porta 22 está aberta pois o serviço openSSH está sendo usado para o acesso à instância \
> A porta 80 está aberta pois o serviço httpd (Apache) está sendo usado para servir arquivos no protocolo HTTP \
> A porta 111 está aberta pois ela é usada para Remote Procedure Call (RPC) no Network File system (NFS). \
> A porta 443 está aberta pois é usada pelo serviço httpd (Apache) para servir arquivos no protocolo HTTPS \
> A porta 2049 está aberta pois é usada para o tráfego do protocolo NFS em redes TCP/IP. Quando o EFS solicita o acesso ao NFS ela é usada.

Caso a porta 2049 ou 111 não estejam abertas, certifique-se de que seu EFS esteja montado com o comando `df- h`. Caso a porta 443 não esteja aberta, certifique de que adicinou a porta ao documento de configuração do apache `httpd.conf`

Você pode acessar o arquivo de configuração do apache executando o comando

`sudo nano /etc/httpd/conf/httpd.conf`

Então, adicionar ao final do arquivo a linha

`Listen 443`

Salve e feche o arquivo

Reinicie o apache  

`sudo systemctl restart httpd`

Execute novamente o comando `nmap` no seu IP para checar o status das portas.


### License
This script is licensed under the GNU General Public License v3.0. See the LICENSE file for details.

