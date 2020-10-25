---
title: GSEA 도구를 이용한 유전자 집합 농축 분석(Gene set enrichment analysis)
tags: rna-seq gsea
categories: omics
---
#### GSEA 소개 
GSEA 홈페이지에는 GSEA를 이렇게 설명하고 있습니다.

'**Gene Set Enrichment Analysis (GSEA)** is a computational method  
that determines whether an a priori defined set of genes shows statistically  
significant, concordant differences between two biological states(e.g. phenotypes).'

즉 유전자 집합을 기반으로 두가지 두 생물학적 상태 간의 차이를 나타내기 위한 통계방법입니다.

#### 분석 도구
간단하게 가입을 하면 총 네 가지 유형의 분석도구를 사용할 수 있습니다.    

**GSEA v4.1.0 for Linux**: 윈도우, 맥, 리눅스 환경을 지원하는 그래픽 사용자 인터페이스(GUI) 기반  
**GSEA v4.1.0 for the command line (all platforms)**: 명령 줄 인터페이스(command line) 기반   
**GSEA v4.1.0 Java Web Start (all platforms)**: 자바 기반  
**GenePattern GSEA Module**: GenePattern의 모듈  

#### 분석 개요:
분석에는 3 가지 유형의 파일이 필요합니다.
1. 유전자 발현 자료(gct)
2. 시료정보 (cls)
3. 유전자 정보 집합(gmt)

파일 작성 방법은 아래의 관련 누리집을 참고하세요.


#### 관련 누리집

- [GSEA](https://www.gsea-msigdb.org/gsea/index.jsp)
- [GSEA wiki](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Main_Page)
- [GSEA Data formats](https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats)