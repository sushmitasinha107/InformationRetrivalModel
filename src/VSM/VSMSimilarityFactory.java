import org.apache.lucene.index.FieldInvertState;
import org.apache.lucene.search.similarities.ClassicSimilarity;
import org.apache.lucene.search.similarities.TFIDFSimilarity;
import org.apache.lucene.util.BytesRef;

public class VSMSimilarityFactory extends ClassicSimilarity {
	
	// Weighting codes
	public boolean doBasic     = true;  // Basic tf-idf
	public boolean doSublinear = false; // Sublinear tf-idf
	public boolean doBoolean   = false; // Boolean
	
	//Scoring codes
	public boolean doCosine    = true;
	public boolean doOverlap   = false;

	private static final long serialVersionUID = 4697609598242172599L;

	// number of terms in the query that were found in the document
		public float coord(int overlap, int maxOverlap) {
			if (doOverlap){
				return 1;
			} else if (doCosine){
				return 1;
			}
			// else: can't get here
			return super.coord(overlap, maxOverlap);
			
		}

	
	public float idf(int docFreq, int numDocs) {
		if (doBoolean || doOverlap){
			return 1;
		}
		// The default behaviour of Lucene is 1 + log (numDocs/(docFreq+1)), which is what we want (default VSM model)
		return super.idf(docFreq, numDocs);	
	}

	@Override
	public float lengthNorm(FieldInvertState arg0) {
		if (doOverlap){
			return 1;
		} else if (doCosine){
			return super.computeNorm(arg0);
		}
		// else: can't get here
		return super.computeNorm(arg0);
	}

	public float queryNorm(float sumOfSquaredWeights){
		if (doOverlap){
			return 1;
		} else if (doCosine){
			return super.queryNorm(sumOfSquaredWeights);
		}
		// else: can't get here
		return super.queryNorm(sumOfSquaredWeights);
	}

	@Override
	public float scorePayload(int arg0, int arg1, int arg2, BytesRef arg3) {
		// TODO Auto-generated method stub
		return 1;
	}

	@Override
	public float sloppyFreq(int arg0) {
		// TODO Auto-generated method stub
		return 1;
	}

	@Override
	public float tf(float freq) {
		// Sublinear tf weighting. Equation taken from [1], pg 127, eq 6.13.
				if (doSublinear){
					if (freq > 0){
						return 1 + (float)Math.log(freq);
					} else {
						return 0;
					}
				} else if (doBoolean){
					return 1;
				}
				// else: doBasic
				// The default behaviour of Lucene is sqrt(freq), but we are implementing the basic VSM model
				return super.tf(freq);
	}
}
