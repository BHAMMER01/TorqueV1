# TORQUE-DRIFT

Um recurso para FiveM que ajusta dinamicamente o torque e a potência do veículo durante derrapagens, proporcionando uma experiência de drift e de
direçao mais realista.

## Funcionalidades

- **Modos de Direção**: 
  - **PADRAO**: Configurações padrão para direção normal
  - **Sensivel**: Mais sensível a pequenos ângulos de derrapagem
  - **Drift**: Configurações otimizadas para drift
  - **desativado**: Desativa completamente o ajuste dinâmico

- **Ajustes Dinâmicos**:
  - Potência e torque são ajustados automaticamente com base no ângulo de derrapagem
  - Zona morta configurável para evitar ajustes desnecessários
  - Multiplicadores de potência e torque baseados na física do veículo

- **Configurações**:
  - Tecla para alternar entre modos (padrão: F5)
  - Ajustes de potência, torque, ângulo e velocidade de impacto
  - Modo de depuração para visualizar informações em tempo real

## Instalação

1. Copie a pasta `torquev1` para a pasta `resources` do seu servidor
2. Adicione `ensure torquev1` no seu arquivo `server.cfg`
3. Configure as Convars no `server.cfg` conforme necessário

## Configuração

Adicione as seguintes Convars no seu `server.cfg` para personalizar o comportamento:

```bash     -- opcional--
set torque_DefaultLevel 0          # Nível padrão (0=Default, 1=Sensitive, 2=Drift, 3=Disabled)
set torque_toggleKey 166           # Tecla para alternar modos (padrão: F5)
set torque_DrawDebug "false"      # Ativar/desativar modo de depuração
set torque_Power 100              # Ajuste de potência base
set torque_Torque 80               # Ajuste de torque base
set torque_Angle 350               # Ângulo de impacto máximo
set torque_Speed 200               # Velocidade de impacto máxima