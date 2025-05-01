# TorqueV1

Apresentação do TorqueV1 - Sistema Avançado de Controle de Torque para FiveM

Olá comunidade!

É com grande satisfação que compartilho com vocês o TorqueV1 , um sistema avançado de controle de torque e física veicular para servidores FiveM. Este script foi desenvolvido para proporcionar uma experiência de direção mais realista e personalizável.

Principais Características:

✅ Múltiplos Modos de Condução:

- Padrão: Configurações padrão para uso geral
- Sensível: Resposta mais rápida e sensível
- Drift: Otimizado para derrapagens controladas
- Desativado: Desativa o sistema quando necessário
✅ Controle Dinâmico de Torque:

- Ajuste automático baseado na velocidade e ângulo de derrapagem
- Multiplicadores de potência e torque configuráveis
- Zona morta personalizável para ativação do sistema
✅ Otimização de Handling:

- Ajustes automáticos de steering lock e tração
- Baseado nas características físicas de cada veículo
- Suporte para veículos personalizados
✅ Interface de Debug:

- Exibe informações em tempo real sobre:
  - Modo atual
  - Velocidade
  - Ângulo de derrapagem
  - Multiplicadores ativos
  - Controles de aceleração/freio
Como Funciona:

O TorqueV1 monitora constantemente:

- Velocidade do veículo
- Ângulo de derrapagem
- Entradas do jogador (aceleração/freio)
Com base nesses dados, o sistema ajusta dinamicamente:

- Multiplicadores de torque e potência
- Configurações de handling
- Resposta do veículo
Configuração Fácil:

lua

Open Folder

1

2

3

4

5

6

7

8

9

10

11

-- Exemplo de configuração básica

config = {

defaultLevel = 0 , -- Modo padrão ao iniciar

drawDebug = true , -- Ativar interface de debug

enableKey = true , -- Habilitar troca de modos

toggleKey = 166 , -- Tecla para trocar modos

power_adj = 100.0 , -- Ajuste de potência

torque_adj = 80.0 , -- Ajuste de torque

angle_impact = 350.0 , -- Impacto do ângulo

speed_impact = 200.0 -- Impacto da velocidade

}

Fold

Como Obter:

O TorqueV1 está disponível gratuitamente para toda a comunidade MRI QBOX. Basta clicar no link abaixo para fazer o download:


Suporte e Atualizações:

Estou comprometido em manter e melhorar o TorqueV1. Se encontrar algum problema ou tiver sugestões, por favor, abra uma issue no repositório ou entre em contato diretamente comigo.

Agradecimentos:

Um agradecimento especial à comunidade MRI QBOX pelo apoio e feedback durante o desenvolvimento deste projeto. Espero que o TorqueV1 contribua para tornar seus servidores ainda mais imersivos e divertidos!

Nota: Este script foi desenvolvido com carinho para a comunidade. Se você gostar do trabalho, considere me apoiar com uma doação ou compartilhando com outros membros da comunidade.

Vamos juntos elevar a qualidade dos servidores FiveM! 🚗💨

Espero que esta versão atualizada atenda às suas expectativas! Se precisar de mais ajustes, estou à disposição.
