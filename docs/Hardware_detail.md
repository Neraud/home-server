
# Hardware detail

This page describes the hardware I currently run my 'production' on.

I tried to keep track of the prices of these parts at the time I bought them.
(that helps to have the real cost and not a remember a vague 'nah, I didn't spend much on that')

## Kubernetes cluster

### Kubernetes Master-1

| Part     | Model                                                                                                                          | Price    |
| -------- | ------------------------------------------------------------------------------------------------------------------------------ | -------- |
| Barebone | [ASRock DeskMini X300](https://www.amazon.de/gp/product/B08NWHGTQQ)                                                            | 136,67 € |
| CPU      | [AMD Ryzen 7 5700G](https://www.rueducommerce.fr/p-ryzen-7-5700g-3846-ghz-amd-3276970-18381.html)                              | 399.90 € |
| Cooler   | [Noctua NH-L9a-AM4](https://www.amazon.fr/gp/product/B075SG1T3X)                                                               | 44,90  € |
| RAM      | 2*16 GB DDR4 3200 CL 16 ([Crucial Ballistix BL2K16G32C16S4B](https://www.amazon.fr/gp/product/B083W5ZRJ1))                     | 157,19 € |
| Storage  | 1 To [WD Blue SN550 NVMe](https://www.rueducommerce.fr/produit/western-digital-wd-blue-sn550-1-to-m-2-pcie-gen3-nvme-98427536) | 109.99 € |

(ordered 2021-08)

### Kubernetes Master-2

| Part     | Model                                                                                                              | Price    |
| -------- | ------------------------------------------------------------------------------------------------------------------ | -------- |
| Barebone | [ASRock DeskMini X300](https://www.amazon.de/-/en/gp/product/B08NWHGTQQ)                                           | 161,34 € |
| CPU      | [AMD Ryzen 7 5700G](https://www.amazon.de/dp/B091J3NYVF/ref=pe_27091401_487027711_TE_SCE_dp_1)                     | 208,73 € |
| Cooler   | [Noctua NH-L9a-AM4](https://www.amazon.de/-/en/gp/product/B075SG1T3X/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1) | 50,32 €  |
| RAM      | 2*16 GB DDR4 3200 CL 22 ([GSKILL RipJaws S44-3200C22D-32GRS](https://www.amazon.de/-/en/gp/product/B08HDL6M19))    | 96,05 €  |
| Storage  | 1 To [WD Blue SN570 NVMe](https://www.amazon.de/-/en/gp/product/B09HKDQ1RN)                                        | 70,49 €  |

(ordered 2022-12)

### Kubernetes Master-3

| Part     | Model                                                                                                                           | Price    |
| -------- | ------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [ASRock DeskMini X300](https://www.amazon.de/-/en/gp/product/B08NWHGTQQ)                                                        | 161,34 € |
| CPU      | [AMD Ryzen 7 5700G](https://www.amazon.de/dp/B091J3NYVF/ref=pe_27091401_487027711_TE_SCE_dp_1)                                  | 208,73 € |
| Cooler   | [Noctua NH-L9a-AM4](https://www.amazon.de/-/en/gp/product/B075SG1T3X/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1)              | 50,32 €  |
| RAM      | 2*16 GB DDR4 3200 CL 22 ([GSKILL RipJaws S44-3200C22D-32GRS](https://www.amazon.de/-/en/gp/product/B08HDL6M19))                 | 96,05 €  |
| Storage  | 1 TB [WD Blue SN570 NVMe](https://www.rueducommerce.fr/p-disque-ssd-nvme-wd-blue-sn570-1-to-western-digital-3363012-18409.html) | 69,89 €  |

(ordered 2022-12)

### Kubernetes Node-3

| Part     | Model                                                                                                    | Price    |
| -------- | -------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [ASRock DeskMini B760](https://www.amazon.de/dp/B0CLTNC6V6)                                              | 208,73 € |
| CPU      | [Intel Core™ i5 14500](https://www.amazon.de/dp/B0CQ2XT4RT)                                              | 254,87 € |
| Cooler   | [Noctua NH-L9i-17xx](https://www.amazon.de/dp/B09HCLB7M3)                                                | 50,32 €  |
| RAM      | 2*32 GB DDR4 3200 CL 22 ([Corsair Performance CMSX64GX4M2A3200C22](https://www.amazon.de/dp/B09DTG3BD7)) | 145,91 € |
| Storage  | 2 TB [WD_BLACK SN770 NVMe](https://www.amazon.de/dp/B09QV5KJHV)                                          | 110,82 € |

(ordered 2024-07)

### Kubernetes Node Home

| Part | Model                                                             | Price |
| ---- | ----------------------------------------------------------------- | ----- |
| Box  | [BoLv Z83II Mini PC](https://www.amazon.fr/gp/product/B01DFJH78U) | 99 €  |

(ordered 2017-08)

This box runs an [Intel Atom x5 Z8350](https://ark.intel.com/products/93361/Intel-Atom-x5-Z8350-Processor-2M-Cache-up-to-1-92-GHz-) CPU, with 2 GB of DDR3 RAM and 32GB of onboard flash storage.

## Accessories

### Coral TPU

| Part | Model                                                                                        | Price   |
| ---- | -------------------------------------------------------------------------------------------- | ------- |
| TPU  | [Google Coral USB Accelerator Edge TPU AI](https://www.amazon.de/-/en/gp/product/B07S214S5Y) | 96,82 € |

(ordered 2021-08)

## NAS

Media and backups are stored on a Synology NAS

### NAS-1

Synology NAS DS1621+, with 4 Seagate Enterprise Exos X16 12T (ST12000NM001G) and 2 Seagate Enterprise Exos X16 14T (ST14000NM001G) in SHR2 mode.

| Part   | Model                                                                                                                                                        | Price    |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| NAS    | [DS1621+](https://www.amazon.de/-/en/gp/product/B08JH22W42)                                                                                                  | 884,36 € |
| Drives | 4*[Seagate Enterprise Exos X16 12T](https://www.alternate.fr/Seagate/Enterprise-Exos-X16-3-Zoll-12000-Go-S%C3%A9rie-ATA-III-Disque-dur/html/product/1694652) | 4*278 €  |
| Drives | 2*[Seagate Enterprise Exos X16 14T](https://www.alternate.fr/Seagate/Exos-X16-3-Zoll-14000-Go-S%C3%A9rie-ATA-III-Disque-dur/html/product/1603523)            | 4*267 €  |
| NIC    | [Synology E10G18-T1 Network Card Ethernet 10000Mbps](https://www.amazon.de/-/en/gp/product/B07GBGLV37/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)      | 151,96 € |

(ordered 2021-04)

## Network

| Part              | Model                                                                                                         | Price   |
| ----------------- | ------------------------------------------------------------------------------------------------------------- | ------- |
| Router            | [UniFi Security Gateway 3P](https://www.amazon.fr/gp/product/B00LV8YZLK)                                      | 118,79€ |
| Switch            | [UniFi Switch Lite 16 PoE](https://store.ui.com/collections/unifi-network-switching/products/usw-lite-16-poe) | 160€    |
| Switch            | [UniFi Switch 8 POE-60W](https://www.amazon.fr/gp/product/B004BQCKXO)                                         | 110,72€ |
| Switches          | a few Netgear G108/[GS108](https://www.amazon.fr/gp/product/B000092RRM)                                       | 30-40€  |
| Wifi Access Point | [UniFi AP-AC-LR](https://www.amazon.fr/gp/product/B016K5A06C)                                                 | 96,42€  |

## Graveyard

### Old Kubernetes Master

| Part     | Model                  | Price    |
| -------- | ---------------------- | -------- |
| Barebone | Intel NUC BOXDC3217IYE | 434,94 € |
| RAM      | 2*4 GB DDR3 (G.Skill)  | (incl.)  |
| Storage  | Crucial M4 64 GB       | (incl.)  |

(ordered 2013-07)
(dead 2019-08, won't boot after changing the dead fan)

This NUC runs an [Intel i3-3217U](https://ark.intel.com/products/65697/Intel-Core-i3-3217U-Processor-3M-Cache-1-80-GHz-) CPU.

### Old Kubernetes Master

| Part     | Model                                                                                      | Price    |
| -------- | ------------------------------------------------------------------------------------------ | -------- |
| Barebone | [Intel NUC 6i5SYH](https://www.amazon.fr/gp/product/B018Q0GN60)                            | 437,29 € |
| RAM      | 2*16 GB DDR4 2133 ([Crucial CT2K16G4SFD8213](https://www.amazon.fr/gp/product/B015YPB8ME)) | 110,52 € |
| Storage  | [Samsung 850 EVO M.2 500 GB](https://www.amazon.fr/gp/product/B00TGIW1XG)                  | 165,32 € |

(ordered 2016-08)

This NUC runs an [Intel i5-6260U](https://ark.intel.com/products/91160/Intel-Core-i5-6260U-Processor-4M-Cache-up-to-2-90-GHz-) CPU.

Decommissioned around 2022-12 after more than 6 years of service !

### Old NAS-1

| Part   | Model                                                                                             | Price   |
| ------ | ------------------------------------------------------------------------------------------------- | ------- |
| NAS    | [DS415+](https://www.synology.com/en-global/products/DS415+)                                      | xx,xx € |
| Drives | 4*[WD Red 6To](https://shop.westerndigital.com/products/internal-drives/wd-red-sata-hdd#WD60EFAX) | xx,xx € |

Decommissioned after having to solder a resistor to fix the Atom issue and starting to receive errors from the drives (after 6.5 years of power-on time !).

### Old Kubernetes Node-1

| Part     | Model                                                                                                                              | Price    |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [Intel NUC8i5BEH](https://www.amazon.fr/Intel-NUC-Kit-NUC8i5BEH-Generation/dp/B07JCF1LCL)                                          | 373,01 € |
| RAM      | 2*16 GB DDR4 2400 ([Kingston HyperX HX424S14IBK2/32](https://www.amazon.fr/HyperX-HX424S14IBK2-32-Mémoire-Notebook/dp/B01BNJL8I4)) | 168,25 € |
| Storage  | [WD Blue SN500 NVME](https://www.amazon.fr/gp/product/B07P7TFKRH)                                                                  | 65,45 €  |

(ordered 2019-05)

This NUC runs an [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) CPU.
Decommissioned on 2024-07 after after 5 years of service.

### Old Kubernetes Node-2

| Part     | Model                                                                                                                              | Price    |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [Intel NUC8i5BEH](https://www.amazon.fr/Intel-NUC-Kit-NUC8i5BEH-Generation/dp/B07JCF1LCL)                                          | 381,07 € |
| RAM      | 2*16 GB DDR4 2400 ([Kingston HyperX HX424S14IBK2/32](https://www.amazon.fr/HyperX-HX424S14IBK2-32-Mémoire-Notebook/dp/B01BNJL8I4)) | 140,06 € |
| Storage  | [WD Blue SN500 SATA](https://www.amazon.fr/gp/product/B073SBX6TY/)                                                                 | 63,43 €  |

(ordered 2019-08)

This NUC runs an [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) CPU.
Decommissioned on 2024-07 after after 5 years of service.
