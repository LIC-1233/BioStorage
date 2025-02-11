# 使用bcftools从bed格式的数据生成含contig头的vcf文件及其index
# 带index的vcf可以让vep启用多线程
# 输入：vep_input.vcf 可以由bed格式转换得到。如下
# ------------------------------------------------------------
# ##fileformat=VCFv4.2
# #CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO
# chrMT   73      .       A       G       60      .       .
# chrMT   235     .       A       G       60      .       .
# ------------------------------------------------------------
# 输出：vep_input_header_sort.vcf.gz vep_input_header_sort.vcf.gz.csi

bcftools query -f '%CHROM\t%POS\n' vep_input.vcf | \
awk '{chrom[$1]=$1; if ($2 > len[$1]) len[$1]=$2} END {print "##fileformat=VCFv4.2"; for (c in chrom) print "##contig=<ID=" c ",length=" len[c] ">"; print "#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO"}' > contigs.txt
bcftools reheader --header contigs.txt vep_input.vcf > vep_input_header.vcf
bcftools sort vep_input_header.vcf > vep_input_header_sort.vcf
bgzip -k vep_input_header_sort.vcf vep_input_header_sort.vcf.gz
bcftools index vep_input_header_sort.vcf.gz
