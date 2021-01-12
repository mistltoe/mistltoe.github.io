---
title: GSEA와 Cytoscape을 이용한 Enrichment Map Visualization 분석
tags: rna-seq gsea cytoscape, enrichment_map
categories: omics
---
#### 분석 개요
GSEA 도구내 분석기법인 Enrichment Map Visualization 활용

#### 필요사항
* GSEA
* Cytoscape
* Cytoscape의 Enrichment Map 플러그인
* GSEA 분석 결과

#### 설정값
* 기본값
    - P-value Cutoff: 0.005
    - FDR Q-value Cutoff: 0.1
* 내 분석값
    - P-value Cutoff: 0.05
    - FDR Q-value Cutoff: 0.2
    
* GSEA Tutorial    
    - Very permissive: p-value < 0.05, FDR < 0.25
    - Moderately permissive: p-value < 0.01, FDR < 0.1
    - Moderately conservative: p-value < 0.005, FDR < 0.075
    - Conservative: p-value < 0.001, FDR < 0.05    

#### 관련 누리집
- [GSEA Tutorial](https://enrichmentmap.readthedocs.io/en/docs-2.2/Tutorials.html)
- [Tips on Parameter Choice](https://enrichmentmap.readthedocs.io/en/docs-2.2/Parameters.html#parameters)
- [Cytoscape](https://cytoscape.org/)
- [EnrichmentMap plugin](http://apps.cytoscape.org/apps/enrichmentmap)