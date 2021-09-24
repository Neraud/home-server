
# Hardware detail

This page describes the hardware I currently run my 'production' on.

I tried to keep track of the prices of these parts at the time I bought them.
(that helps to have the real cost and not a remember a vague 'nah, I didn't spend much on that')

## Kubernetes cluster

### Kubernetes Master-1

| Part     | Model                                                                                      | Price    |
| -------- | ------------------------------------------------------------------------------------------ | -------- |
| Barebone | [Intel NUC 6i5SYH](https://www.amazon.fr/gp/product/B018Q0GN60)                            | 437,29 € |
| RAM      | 2*16 GB DDR4 2133 ([Crucial CT2K16G4SFD8213](https://www.amazon.fr/gp/product/B015YPB8ME)) | 110,52 € |
| Storage  | [Samsung 850 EVO M.2 500 GB](https://www.amazon.fr/gp/product/B00TGIW1XG)                  | 165,32 € |

(ordered 2016-08)

This NUC runs an [Intel i5-6260U](https://ark.intel.com/products/91160/Intel-Core-i5-6260U-Processor-4M-Cache-up-to-2-90-GHz-) CPU.

### Kubernetes Master-2

| Part     | Model                                                                                                                              | Price    |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [Intel NUC8i5BEH](https://www.amazon.fr/Intel-NUC-Kit-NUC8i5BEH-Generation/dp/B07JCF1LCL)                                          | 373,01 € |
| RAM      | 2*16 GB DDR4 2400 ([Kingston HyperX HX424S14IBK2/32](https://www.amazon.fr/HyperX-HX424S14IBK2-32-Mémoire-Notebook/dp/B01BNJL8I4)) | 168,25 € |
| Storage  | [WD Blue SN500 NVME](https://www.amazon.fr/gp/product/B07P7TFKRH)                                                                  | 65,45 €  |

(ordered 2019-05)

This NUC runs an [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) CPU.

### Kubernetes Master-3

| Part     | Model                                                                                                                              | Price    |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [Intel NUC8i5BEH](https://www.amazon.fr/Intel-NUC-Kit-NUC8i5BEH-Generation/dp/B07JCF1LCL)                                          | 381,07 € |
| RAM      | 2*16 GB DDR4 2400 ([Kingston HyperX HX424S14IBK2/32](https://www.amazon.fr/HyperX-HX424S14IBK2-32-Mémoire-Notebook/dp/B01BNJL8I4)) | 140,06 € |
| Storage  | [WD Blue SN500 SATA](https://www.amazon.fr/gp/product/B073SBX6TY/)                                                                 | 63,43 €  |

(ordered 2019-08)

This NUC runs an [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) CPU.

### Kubernetes Node Home

| Part | Model                                                             | Price |
| ---- | ----------------------------------------------------------------- | ----- |
| Box  | [BoLv Z83II Mini PC](https://www.amazon.fr/gp/product/B01DFJH78U) | 99 €  |

(ordered 2017-08)

This box runs an [Intel Atom x5 Z8350](https://ark.intel.com/products/93361/Intel-Atom-x5-Z8350-Processor-2M-Cache-up-to-1-92-GHz-) CPU, with 2 GB of DDR3 RAM and 32GB of onboard flash storage.

### Kubernetes Node-1

| Part     | Model                                                                                                                          | Price    |
| -------- | ------------------------------------------------------------------------------------------------------------------------------ | -------- |
| Barebone | [ASRock DeskMini X300](https://www.amazon.de/gp/product/B08NWHGTQQ)                                                            | 136,67 € |
| CPU      | [AMD Ryzen 7 5700G](https://www.rueducommerce.fr/p-ryzen-7-5700g-3846-ghz-amd-3276970-18381.html)                              | 399.90 € |
| Cooler   | [Noctua NH-L9a-AM4](https://www.amazon.fr/gp/product/B075SG1T3X)                                                               | 44,90  € |
| RAM      | 2*16 GB DDR4 3200 CL 16 ([Crucial Ballistix BL2K16G32C16S4B](https://www.amazon.fr/gp/product/B083W5ZRJ1))                     | 157,19 € |
| Storage  | 1 To [WD Blue SN550 NVMe](https://www.rueducommerce.fr/produit/western-digital-wd-blue-sn550-1-to-m-2-pcie-gen3-nvme-98427536) | 109.99 € |

## Accessories

### Coral TPU

| Part | Model                                                                                        | Price   |
| ---- | -------------------------------------------------------------------------------------------- | ------- |
| TPU  | [Google Coral USB Accelerator Edge TPU AI](https://www.amazon.de/-/en/gp/product/B07S214S5Y) | 96,82 € |

(ordered 2021-08)

## NAS

Media and backups are stored on a Synology NAS DS415+
With 4 WD Red 6To (WD60EFRX) in SHR mode.

## Network

| Part              | Model                                                                    | Price   |
| ----------------- | ------------------------------------------------------------------------ | ------- |
| Router            | [UniFi Security Gateway 3P](https://www.amazon.fr/gp/product/B00LV8YZLK) | 118,79€ |
| Switch            | [UniFi Switch 8 POE-60W](https://www.amazon.fr/gp/product/B004BQCKXO)    | 110,72€ |
| Switches          | a few Netgear G108/[GS108](https://www.amazon.fr/gp/product/B000092RRM)  | 30-40€  |
| Wifi Access Point | [UniFi AP-AC-LR](https://www.amazon.fr/gp/product/B016K5A06C)            | 96,42€  |

## Graveyard

### Old Kubernetes Master-1

| Part     | Model                  | Price    |
| -------- | ---------------------- | -------- |
| Barebone | Intel NUC BOXDC3217IYE | 434,94 € |
| RAM      | 2*4 GB DDR3 (G.Skill)  | (incl.)  |
| Storage  | Crucial M4 64 GB       | (incl.)  |

(ordered 2013-07)
(dead 2019-08, won't boot after changing the dead fan)

This NUC runs an [Intel i3-3217U](https://ark.intel.com/products/65697/Intel-Core-i3-3217U-Processor-3M-Cache-1-80-GHz-) CPU.
