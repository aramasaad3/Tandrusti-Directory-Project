import { useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, getDocs, addDoc, updateDoc, deleteDoc, doc } from 'firebase/firestore';
import { Edit2, Trash2, X, Save, Plus } from 'lucide-react';

export default function TestsPanel() {
  const [tests, setTests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingId, setEditingId] = useState(null);
  const [isAdding, setIsAdding] = useState(false);
  
  // Form State
  const initialForm = {
    testName: '', category: '', duration: '', 
    whatToExpect: '', preparationInstruction: '',
    whatToExpect_ku: '', preparationInstruction_ku: ''
  };
  const [formData, setFormData] = useState(initialForm);

  const fetchTests = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, 'tests'));
      const docsData = snap.docs.map(d => ({ id: d.id, ...d.data() }));
      setTests(docsData);
    } catch (error) {
      console.error("Error fetching tests", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchTests();
  }, []);

  const handleEditClick = (test) => {
    setEditingId(test.id);
    setIsAdding(false);
    setFormData({
      testName: test.testName || '',
      category: test.category || '',
      duration: test.duration || '',
      whatToExpect: test.whatToExpect || '',
      preparationInstruction: test.preparationInstruction || '',
      whatToExpect_ku: test.whatToExpect_ku || '',
      preparationInstruction_ku: test.preparationInstruction_ku || '',
    });
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this lab test?")) {
      await deleteDoc(doc(db, 'tests', id));
      fetchTests();
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      if (isAdding) {
        await addDoc(collection(db, 'tests'), formData);
      } else if (editingId) {
        await updateDoc(doc(db, 'tests', editingId), formData);
      }
      
      setEditingId(null);
      setIsAdding(false);
      fetchTests();
    } catch (err) {
      alert("Error saving: " + err.message);
    }
  };

  const resetForm = () => {
    setFormData(initialForm);
    setEditingId(null);
    setIsAdding(false);
  };

  return (
    <div className="bg-surface rounded-xl p-8 border border-borderLight shadow-sm">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-bold">Lab Tests Guide</h3>
        {!isAdding && !editingId && (
          <button 
            onClick={() => { setIsAdding(true); setFormData(initialForm); }}
            className="flex items-center bg-primary hover:bg-primaryDark text-white px-4 py-2 rounded-lg font-medium transition-colors"
          >
            <Plus className="w-5 h-5 mr-2" /> Add New Test
          </button>
        )}
      </div>

      {loading && <p className="text-textMuted italic">Loading tests from Firestore...</p>}

      {/* Editor / Add Form */}
      {(isAdding || editingId) && (
        <form onSubmit={handleSave} className="bg-background p-6 rounded-lg border border-borderLight mb-8">
          <div className="flex justify-between items-center mb-4">
            <h4 className="text-lg font-bold">{isAdding ? 'Add New Lab Test' : '✏️ Edit Lab Test'}</h4>
            <button type="button" onClick={resetForm} className="text-textMuted hover:text-red-500">
              <X className="w-5 h-5" />
            </button>
          </div>
          
          <div className="grid grid-cols-3 gap-4 border-b border-borderLight pb-4 mb-4">
            <div>
              <label className="block text-sm font-semibold mb-1">Test Name</label>
              <input required value={formData.testName} onChange={e => setFormData({...formData, testName: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. Complete Blood Count (CBC)" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Category</label>
              <input required value={formData.category} onChange={e => setFormData({...formData, category: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. Diagnostic" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Duration</label>
              <input required value={formData.duration} onChange={e => setFormData({...formData, duration: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. 15-30 min" />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {/* English Content */}
            <div className="space-y-4 pr-2 border-r border-borderLight">
               <h5 className="font-bold text-sm text-primary uppercase">Content (English)</h5>
               <div>
                 <label className="block text-xs font-semibold mb-1">What To Expect</label>
                 <textarea required value={formData.whatToExpect} onChange={e => setFormData({...formData, whatToExpect: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="3" placeholder="Description of the test..." />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1">Preparation Instructions</label>
                 <textarea required value={formData.preparationInstruction} onChange={e => setFormData({...formData, preparationInstruction: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="3" placeholder="e.g. Fasting for 12 hours..." />
               </div>
            </div>

            {/* Kurdish Content */}
            <div className="space-y-4 pl-2" dir="rtl">
               <h5 className="font-bold text-sm text-blue-600 uppercase text-right">ناوەڕۆک (Kurdish)</h5>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">پێشبینی چی دەکەیت؟ (What To Expect)</label>
                 <textarea value={formData.whatToExpect_ku} onChange={e => setFormData({...formData, whatToExpect_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="3" placeholder="Kurdish translation..." />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">ئامادەکاری (Preparation)</label>
                 <textarea value={formData.preparationInstruction_ku} onChange={e => setFormData({...formData, preparationInstruction_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="3" placeholder="Kurdish translation..." />
               </div>
            </div>
          </div>

          <button type="submit" className="mt-6 flex items-center bg-primary text-white px-6 py-2 rounded-lg font-bold hover:bg-primaryDark transition-colors">
             <Save className="w-5 h-5 mr-2" /> Save Lab Test
          </button>
        </form>
      )}

      {/* Directory Table */}
      {!loading && tests.length > 0 && (
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-background border-b border-borderLight text-textMuted uppercase text-xs">
                <th className="p-4 font-semibold">Test Name</th>
                <th className="p-4 font-semibold">Category</th>
                <th className="p-4 font-semibold">Duration</th>
                <th className="p-4 font-semibold text-center">RTL (Kurdish)?</th>
                <th className="p-4 font-semibold text-center">Actions</th>
              </tr>
            </thead>
            <tbody>
              {tests.map(test => {
                const hasKurdish = !!(test.whatToExpect_ku || test.preparationInstruction_ku);
                return (
                  <tr key={test.id} className="border-b border-borderLight hover:bg-background transition-colors">
                    <td className="p-4 font-medium">{test.testName}</td>
                    <td className="p-4 text-sm text-textMuted">{test.category}</td>
                    <td className="p-4 text-sm text-textMuted">{test.duration}</td>
                    <td className="p-4 text-center">
                      {hasKurdish ? (
                        <span className="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">YES</span>
                      ) : (
                        <span className="bg-red-100 text-red-700 px-2 py-1 rounded text-xs font-bold">NO</span>
                      )}
                    </td>
                    <td className="p-4 flex items-center justify-center gap-3">
                      <button onClick={() => handleEditClick(test)} className="text-blue-500 hover:text-blue-700 bg-blue-50 p-2 rounded-lg transition-colors" title="Edit">
                        <Edit2 className="w-4 h-4" />
                      </button>
                      <button onClick={() => handleDelete(test.id)} className="text-red-500 hover:text-red-700 bg-red-50 p-2 rounded-lg transition-colors" title="Delete">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
