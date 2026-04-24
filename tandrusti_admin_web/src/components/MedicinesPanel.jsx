import { useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, getDocs, setDoc, addDoc, updateDoc, deleteDoc, doc } from 'firebase/firestore';
import { Edit2, Trash2, X, Save, Plus } from 'lucide-react';

export default function MedicinesPanel() {
  const [medicines, setMedicines] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingId, setEditingId] = useState(null);
  const [isAdding, setIsAdding] = useState(false);
  
  // Form State
  const initialForm = {
    scientificName: '', commonBrands: '', indications: '', 
    sideEffects: '', usageInstructions: '', dosage: '', contraindications: '',
    // Kurdish fields
    usageInstructions_ku: '', sideEffects_ku: '', dosage_ku: '', contraindications_ku: ''
  };
  const [formData, setFormData] = useState(initialForm);

  const fetchMedicines = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, 'medicines'));
      const docsData = snap.docs.map(d => ({ id: d.id, ...d.data() }));
      setMedicines(docsData);
    } catch (error) {
      console.error("Error fetching medicines", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchMedicines();
  }, []);

  const handleEditClick = (med) => {
    setEditingId(med.id);
    setIsAdding(false);
    
    // Convert array back to string for input field
    const brandsString = Array.isArray(med.commonBrands) ? med.commonBrands.join(", ") : (med.commonBrands || '');
    
    setFormData({
      scientificName: med.scientificName || '',
      commonBrands: brandsString,
      indications: med.indications || '',
      sideEffects: med.sideEffects || '',
      usageInstructions: med.usageInstructions || '',
      dosage: med.dosage || '',
      contraindications: med.contraindications || '',
      usageInstructions_ku: med.usageInstructions_ku || '',
      sideEffects_ku: med.sideEffects_ku || '',
      dosage_ku: med.dosage_ku || '',
      contraindications_ku: med.contraindications_ku || '',
    });
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this medicine?")) {
      await deleteDoc(doc(db, 'medicines', id));
      fetchMedicines();
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      // Convert commonBrands back to Array
      const brandsArray = formData.commonBrands.split(',').map(s => s.trim()).filter(s => s !== '');
      
      const payload = {
        ...formData,
        commonBrands: brandsArray
      };

      if (isAdding) {
        const cleanId = `m_${Date.now()}`;
        await setDoc(doc(db, 'medicines', cleanId), payload);
      } else if (editingId) {
        await updateDoc(doc(db, 'medicines', editingId), payload);
      }
      
      setEditingId(null);
      setIsAdding(false);
      fetchMedicines();
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
        <h3 className="text-xl font-bold">Medicines & Drugs</h3>
        {!isAdding && !editingId && (
          <button 
            onClick={() => { setIsAdding(true); setFormData(initialForm); }}
            className="flex items-center bg-primary hover:bg-primaryDark text-white px-4 py-2 rounded-lg font-medium transition-colors"
          >
            <Plus className="w-5 h-5 mr-2" /> Add New Medicine
          </button>
        )}
      </div>

      {loading && <p className="text-textMuted italic">Loading medicines from Firestore...</p>}

      {/* Editor / Add Form */}
      {(isAdding || editingId) && (
        <form onSubmit={handleSave} className="bg-background p-6 rounded-lg border border-borderLight mb-8">
          <div className="flex justify-between items-center mb-4">
            <h4 className="text-lg font-bold">{isAdding ? 'Add New Medicine' : '✏️ Edit Medicine'}</h4>
            <button type="button" onClick={resetForm} className="text-textMuted hover:text-red-500">
              <X className="w-5 h-5" />
            </button>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold mb-1">Scientific Name</label>
              <input required value={formData.scientificName} onChange={e => setFormData({...formData, scientificName: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. Paracetamol" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Common Brands (comma separated)</label>
              <input value={formData.commonBrands} onChange={e => setFormData({...formData, commonBrands: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" placeholder="e.g. Panadol, Tylenol" />
            </div>
            <div className="col-span-2">
              <label className="block text-sm font-semibold mb-1">Indications</label>
              <textarea value={formData.indications} onChange={e => setFormData({...formData, indications: e.target.value})} className="w-full border p-2 rounded outline-none focus:ring-2 focus:ring-primary" rows="2" placeholder="What is it used for?"></textarea>
            </div>
            
            {/* Split layout for English / Kurdish */}
            <div className="space-y-4 pr-2 border-r border-borderLight">
               <h5 className="font-bold text-sm text-primary uppercase">Content (English)</h5>
               <div>
                 <label className="block text-xs font-semibold mb-1">Usage Instructions</label>
                 <textarea required value={formData.usageInstructions} onChange={e => setFormData({...formData, usageInstructions: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="2" />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1">Dosage</label>
                 <textarea value={formData.dosage} onChange={e => setFormData({...formData, dosage: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="2" />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1">Side Effects</label>
                 <textarea required value={formData.sideEffects} onChange={e => setFormData({...formData, sideEffects: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="2" />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1">Contraindications</label>
                 <textarea value={formData.contraindications} onChange={e => setFormData({...formData, contraindications: e.target.value})} className="w-full border p-2 rounded outline-none text-sm" rows="2" />
               </div>
            </div>

            <div className="space-y-4 pl-2" dir="rtl">
               <h5 className="font-bold text-sm text-blue-600 uppercase text-right">ناوەڕۆک (Kurdish)</h5>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">ڕێنمایی بەکارهێنان</label>
                 <textarea value={formData.usageInstructions_ku} onChange={e => setFormData({...formData, usageInstructions_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="2" placeholder="Kurdish translation..." />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">بڕی ژەمەکان</label>
                 <textarea value={formData.dosage_ku} onChange={e => setFormData({...formData, dosage_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="2" placeholder="Kurdish translation..." />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">کاریگەرییە لاوەکییەکان</label>
                 <textarea value={formData.sideEffects_ku} onChange={e => setFormData({...formData, sideEffects_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="2" placeholder="Kurdish translation..." />
               </div>
               <div>
                 <label className="block text-xs font-semibold mb-1 text-right">ئەو حاڵەتانەی نابێت بەکاربهێنرێت</label>
                 <textarea value={formData.contraindications_ku} onChange={e => setFormData({...formData, contraindications_ku: e.target.value})} className="w-full border p-2 rounded outline-none text-sm font-kurdish text-right" rows="2" placeholder="Kurdish translation..." />
               </div>
            </div>
          </div>

          <button type="submit" className="mt-6 flex items-center bg-primary text-white px-6 py-2 rounded-lg font-bold hover:bg-primaryDark transition-colors">
            <Save className="w-5 h-5 mr-2" /> Save Medicine
          </button>
        </form>
      )}

      {/* Directory Table */}
      {!loading && medicines.length > 0 && (
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-background border-b border-borderLight text-textMuted uppercase text-xs">
                <th className="p-4 font-semibold">Scientific Name</th>
                <th className="p-4 font-semibold">Common Brands</th>
                <th className="p-4 font-semibold text-center">RTL (Kurdish) Content?</th>
                <th className="p-4 font-semibold text-center">Actions</th>
              </tr>
            </thead>
            <tbody>
              {medicines.map(med => {
                const hasKurdish = !!(med.usageInstructions_ku || med.sideEffects_ku);
                const brands = Array.isArray(med.commonBrands) ? med.commonBrands.join(", ") : med.commonBrands;
                return (
                  <tr key={med.id} className="border-b border-borderLight hover:bg-background transition-colors">
                    <td className="p-4 font-medium">{med.scientificName}</td>
                    <td className="p-4 text-sm text-textMuted truncate max-w-xs">{brands}</td>
                    <td className="p-4 text-center">
                      {hasKurdish ? (
                        <span className="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">YES</span>
                      ) : (
                        <span className="bg-red-100 text-red-700 px-2 py-1 rounded text-xs font-bold">NO</span>
                      )}
                    </td>
                    <td className="p-4 flex items-center justify-center gap-3">
                      <button onClick={() => handleEditClick(med)} className="text-blue-500 hover:text-blue-700 bg-blue-50 p-2 rounded-lg transition-colors" title="Edit">
                        <Edit2 className="w-4 h-4" />
                      </button>
                      <button onClick={() => handleDelete(med.id)} className="text-red-500 hover:text-red-700 bg-red-50 p-2 rounded-lg transition-colors" title="Delete">
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
