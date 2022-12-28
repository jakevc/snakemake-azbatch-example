import pandas as pd
import altair as alt
from pysam import VariantFile

quals = pd.DataFrame({"qual": [record.qual for record in VariantFile(snakemake.input[0])]})

chart = alt.Chart(quals).mark_bar().encode(
    alt.X("qual", bin=True),
    alt.Y("count()")
)

chart.save(snakemake.output[0])
