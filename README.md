#Projeto Compasso - Linux + AWS

##


##
## Usando o Script de Provisionamento de Instancia EC2
Através do uso da AWS CLI é possível automatizar a criação da instância executando um script. 

Neste exemplo, o script provisiona uma instância com as seguintes características:

Amazon EC2 
Sistema Operacional: `Amazon Linux 2`
Região: `us-east-1` 
Familia: `t3.small`
Volume: `SSD 16GB`

Também, esse script irá anexar Alocar e anexar um IP elástico à instância, abrir portas de comunicação para acesso público, criar uma nova subnet, internet gateway e VPC.

Um novo grupo de segurança denominado `Compass Univesp Uri` é criado e regras são adicionadas para autorizar o tráfego nas portas `22, 80, 443, 111/TCP e UDP e 2049/TCP e UDP`. Um novo par de chaves denominado PB Compass Univesp também é criado para acesso à instância. Finalmente, tags são adicionadas à instância para identificar sua finalidade, centro de custo, projeto e tipo de recurso.

## Pre-requisitos.
* AWS CLI instalado e configurado com as credenciais apropriadas.
* Ambiente de shell Bash.
## Como usar
1. Clone ou faça o download do script para sua máquina local.
2. Abra um terminal e navegue até o diretório onde o script está localizado.
3. Torne o script executável executando chmod +x ec2_provisioning.sh.
4. Defina as variáveis de ambiente necessárias no script, como o Nome da VPC e a região, e modifique o script de acordo com suas necessidades.
5. Execute o script executando ./ec2_provisioning.sh.
6. Aguarde o script ser concluído. Pode levar alguns minutos para a instância ser lançada e ficar disponível.
7. Depois que o script for concluído, você deverá ver o ID da instância e o endereço IP público impressos no console. Você pode usar essas informações para acessar a instância.

### License
This script is licensed under the GNU General Public License v3.0. See the LICENSE file for details.

