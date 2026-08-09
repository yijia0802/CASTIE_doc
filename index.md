---
layout: default
title: CASTIE
nav_order: 1
has_children: true
permalink: /
---
------

# CASTIE

CASTIE (Context-Aware Single-cell Tool for Investigating regulatory Effects) builds on the SAIGE methods, facilitates the analysis of heterogeneous genetic effects across different cell level and donor contexts directly from single-cell data efficiently, eliminating the need for pseudobulk aggregation.

<img src="{{ site.baseurl }}/img/CASTIE_overview.jpeg"
     alt="CASTIE Framework">

## Analysis Workflow

<img src="{{ site.baseurl }}/img/CASTIE_steps.jpeg"
     alt="CASTIE workflow overview showing the multi-step analysis pipeline">

## Docker Installation

### Prerequisites
- Docker installed on your system
- Access to pull images from Docker Hub

### Pull the SAIGE-QTL Docker Image

The pre-built Docker image can be pulled directly from Docker Hub:

```bash
docker pull yijia0802/saigeqtldynamic0.2.5.8:latest
```

CASTIE consists of three steps. Step 1 fits the null model, Step 2 obtains variant-level summary statistics for each gene, and Step 3 uses the ACAT method to calculate gene-level p-values. I’ve attached example shell scripts for running all three steps. Steps 1 and 2 can be executed directly within the Docker container. 
```
step1_fitNULLGLMM_qtl.R
step2_tests_qtl.R
```
Step 3 can be excuted outside of the container with the provided script. 

## Support

This work is in progress. For any questions, please contact Christiana Liu: [liuyijia@broadinstitute.org](mailto:liuyijia@broadinstitute.org).
