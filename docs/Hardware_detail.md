
# Hardware deail

This page describes the hardware I currently run my 'production' on.

I tried to keep track of the prices of these parts at the time I bought them.
(that helps to have the real cost and not a remember a vague 'nah, I didn't spend much on that')

## Kubernetes cluster

### Kubernetes Master-1

| Part     | Model                  |
| -------- | ---------------------- |
| Barebone | Intel NUC BOXDC3217IYE |
| RAM      | 2*4 GB DDR3 (G.Skill)  |
| Storage  | Crucial M4 64 GB       |

This NUC runs an [Intel i3-3217U](https://ark.intel.com/products/65697/Intel-Core-i3-3217U-Processor-3M-Cache-1-80-GHz-) CPU.

### Kubernetes Master-2

| Part     | Model                                                                                      | Price    |
| -------- | ------------------------------------------------------------------------------------------ | -------- |
| Barebone | [Intel NUC 6i5SYH](https://www.amazon.fr/gp/product/B018Q0GN60)                            | 437,29 € |
| RAM      | 2*16 GB DDR4 2133 ([Crucial CT2K16G4SFD8213](https://www.amazon.fr/gp/product/B015YPB8ME)) | 110,52 € |
| Storage  | [Samsung 850 EVO M.2 500 GB](https://www.amazon.fr/gp/product/B00TGIW1XG)                  | 165,32 € |

(ordered 2016-08)

This NUC runs an [Intel i5-6260U](https://ark.intel.com/products/91160/Intel-Core-i5-6260U-Processor-4M-Cache-up-to-2-90-GHz-) CPU.

### Kubernetes Master-3

| Part     | Model                                                                                                                              | Price    |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Barebone | [Intel NUC8i5BEH](https://www.amazon.fr/Intel-Nuc-Kit-Nuc8I3Beh-Cartes/dp/B07JB2M5JS)                                              | 373,01 € |
| RAM      | 2*16 GB DDR4 2400 ([Kingston HyperX HX424S14IBK2/32](https://www.amazon.fr/HyperX-HX424S14IBK2-32-Mémoire-Notebook/dp/B01BNJL8I4)) | 168,25 € |
| Storage  | [WD Blue SN500](https://www.amazon.fr/gp/product/B07P7TFKRH)                                                                       | 65,45 €  |

(ordered 2019-05)

This NUC runs an [Intel i5-8259U](https://ark.intel.com/content/www/us/en/ark/products/135935/intel-core-i5-8259u-processor-6m-cache-up-to-3-80-ghz.html) CPU.

### Kubernetes Node Home

| Part | Model                                                              | Price |
| ---- | ------------------------------------------------------------------ | ----- |
| Box  | [BoLv Z83II Mini PC](https://www.amazon.fr/gp/product/B01DFJH78U ) | 99 €  |

This box runs an [Intel Atom x5 Z8350](https://ark.intel.com/products/93361/Intel-Atom-x5-Z8350-Processor-2M-Cache-up-to-1-92-GHz-) CPU, with 2 GB of DDR3 RAM and 32GB of onboard flash storage.

## NAS

Media and backps are stored on a Synology NAS DS415+
With 4 WD Red 6To (WD60EFRX) in SHR mode.

## Network

| Part              | Model                                                                    | Price   |
| ----------------- | ------------------------------------------------------------------------ | ------- |
| Router            | [UniFi Security Gateway 3P](https://www.amazon.fr/gp/product/B00LV8YZLK) | 118,79€ |
| Switch            | [UniFi Switch 8 POE-60W](https://www.amazon.fr/gp/product/B004BQCKXO)    | 110,72€ |
| Switches          | a few Netgear G108/[GS108](https://www.amazon.fr/gp/product/B000092RRM)  | 30-40€  |
| Wifi Access Point | [UniFi AP-AC-LR](https://www.amazon.fr/gp/product/B016K5A06C)            | 96,42€  |
