
source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# dac peripherals

ad_ip_instance axi_adxcvr axi_ad9162_xcvr
ad_ip_parameter axi_ad9162_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9162_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_ad9162_xcvr CONFIG.TX_OR_RX_N 1

ad_ip_instance axi_ad9162 axi_ad9162_core

adi_axi_jesd204_tx_create axi_ad9162_jesd 8

ad_ip_instance axi_dmac axi_ad9162_dma
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_ad9162_dma CONFIG.ID 1
ad_ip_parameter axi_ad9162_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9162_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9162_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_DATA_WIDTH_SRC 256
ad_ip_parameter axi_ad9162_dma CONFIG.DMA_DATA_WIDTH_DEST 256

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9625_xcvr
ad_ip_parameter axi_ad9625_xcvr CONFIG.NUM_OF_LANES 8
ad_ip_parameter axi_ad9625_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9625_xcvr CONFIG.TX_OR_RX_N 0

ad_ip_instance axi_ad9625 axi_ad9625_core

adi_axi_jesd204_rx_create axi_ad9625_jesd 8

ad_ip_instance axi_dmac axi_ad9625_dma
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.ID 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad9625_dma CONFIG.AXI_SLICE_DEST 0
ad_ip_parameter axi_ad9625_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_LENGTH_WIDTH 24
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9625_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_SRC 64
ad_ip_parameter axi_ad9625_dma CONFIG.DMA_DATA_WIDTH_DEST 64

# shared transceiver core

ad_ip_instance util_adxcvr util_fmcomms11_xcvr
ad_ip_parameter util_fmcomms11_xcvr CONFIG.QPLL_FBDIV 0x120
ad_ip_parameter util_fmcomms11_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_fmcomms11_xcvr CONFIG.TX_NUM_OF_LANES 8
ad_ip_parameter util_fmcomms11_xcvr CONFIG.TX_CLK25_DIV 7
ad_ip_parameter util_fmcomms11_xcvr CONFIG.RX_NUM_OF_LANES 8
ad_ip_parameter util_fmcomms11_xcvr CONFIG.RX_CLK25_DIV 7
ad_ip_parameter util_fmcomms11_xcvr CONFIG.RX_DFE_LPM_CFG 0x0904
ad_ip_parameter util_fmcomms11_xcvr CONFIG.RX_CDR_CFG 0x03000023ff10400020

# reference clocks & resets

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0

ad_xcvrpll  tx_ref_clk_0 util_fmcomms11_xcvr/qpll_ref_clk_*
ad_xcvrpll  rx_ref_clk_0 util_fmcomms11_xcvr/cpll_ref_clk_*
ad_xcvrpll  axi_ad9162_xcvr/up_pll_rst util_fmcomms11_xcvr/up_qpll_rst_*
ad_xcvrpll  axi_ad9625_xcvr/up_pll_rst util_fmcomms11_xcvr/up_cpll_rst_*
ad_connect  sys_cpu_resetn util_fmcomms11_xcvr/up_rstn
ad_connect  sys_cpu_clk util_fmcomms11_xcvr/up_clk

# connections (dac)

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9162_xcvr axi_ad9162_jesd
ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 axi_ad9162_core/tx_clk
ad_connect  axi_ad9162_jesd/tx_data_tdata axi_ad9162_core/tx_data
ad_connect  util_fmcomms11_xcvr/tx_out_clk_0 axi_ad9162_fifo/dac_clk
ad_connect  axi_ad9162_core/dac_valid axi_ad9162_fifo/dac_valid
ad_connect  axi_ad9162_core/dac_ddata axi_ad9162_fifo/dac_data
ad_connect  axi_ad9162_core/dac_dunf axi_ad9162_fifo/dac_dunf
ad_connect  axi_ad9162_jesd_rstgen/peripheral_reset axi_ad9162_fifo/dac_rst
ad_connect  sys_cpu_clk axi_ad9162_fifo/dma_clk
ad_connect  sys_cpu_reset axi_ad9162_fifo/dma_rst
ad_connect  sys_cpu_clk axi_ad9162_dma/m_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9162_dma/m_src_axi_aresetn
ad_connect  axi_ad9162_fifo/dma_xfer_req axi_ad9162_dma/m_axis_xfer_req
ad_connect  axi_ad9162_fifo/dma_ready axi_ad9162_dma/m_axis_ready
ad_connect  axi_ad9162_fifo/dma_data axi_ad9162_dma/m_axis_data
ad_connect  axi_ad9162_fifo/dma_valid axi_ad9162_dma/m_axis_valid
ad_connect  axi_ad9162_fifo/dma_xfer_last axi_ad9162_dma/m_axis_last

# connections (adc)

ad_xcvrcon  util_fmcomms11_xcvr axi_ad9625_xcvr axi_ad9625_jesd
ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 axi_ad9625_core/rx_clk
ad_connect  axi_ad9625_jesd/rx_sof axi_ad9625_core/rx_sof
ad_connect  axi_ad9625_jesd/rx_data_tdata axi_ad9625_core/rx_data
ad_connect  axi_ad9625_jesd/rx_data_tvalid axi_ad9625_core/rx_valid
ad_connect  util_fmcomms11_xcvr/rx_out_clk_0 axi_ad9625_fifo/adc_clk
ad_connect  axi_ad9625_jesd_rstgen/peripheral_reset axi_ad9625_fifo/adc_rst
ad_connect  axi_ad9625_core/adc_valid axi_ad9625_fifo/adc_wr
ad_connect  axi_ad9625_core/adc_data axi_ad9625_fifo/adc_wdata
ad_connect  sys_cpu_clk axi_ad9625_fifo/dma_clk
ad_connect  sys_cpu_clk axi_ad9625_dma/s_axis_aclk
ad_connect  sys_cpu_resetn axi_ad9625_dma/m_dest_axi_aresetn
ad_connect  axi_ad9625_fifo/dma_wr axi_ad9625_dma/s_axis_valid
ad_connect  axi_ad9625_fifo/dma_wdata axi_ad9625_dma/s_axis_data
ad_connect  axi_ad9625_fifo/dma_wready axi_ad9625_dma/s_axis_ready
ad_connect  axi_ad9625_fifo/dma_xfer_req axi_ad9625_dma/s_axis_xfer_req
ad_connect  axi_ad9625_core/adc_dovf axi_ad9625_fifo/adc_wovf

# interconnect (cpu)

ad_cpu_interconnect 0x44A60000 axi_ad9162_xcvr
ad_cpu_interconnect 0x44A00000 axi_ad9162_core
ad_cpu_interconnect 0x44A90000 axi_ad9162_jesd
ad_cpu_interconnect 0x7c420000 axi_ad9162_dma
ad_cpu_interconnect 0x44A50000 axi_ad9625_xcvr
ad_cpu_interconnect 0x44A10000 axi_ad9625_core
ad_cpu_interconnect 0x44AA0000 axi_ad9625_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9625_dma

# gt uses hp3, and 100MHz clock for both DRP and AXI4

ad_mem_hp3_interconnect sys_cpu_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_cpu_clk axi_ad9625_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_cpu_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_cpu_clk axi_ad9162_dma/m_src_axi
ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad9625_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9162_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_ad9625_jesd/irq
ad_cpu_interrupt ps-12 mb-12 axi_ad9162_dma/irq
ad_cpu_interrupt ps-13 mb-13 axi_ad9625_dma/irq

# unused

ad_connect  axi_ad9162_fifo/bypass GND

