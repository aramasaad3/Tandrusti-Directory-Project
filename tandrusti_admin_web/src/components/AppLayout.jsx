import { Outlet, Link, useLocation } from 'react-router-dom';
import { auth } from '../firebase';
import { signOut } from 'firebase/auth';
import { LayoutDashboard, Users, Pill, Activity, LogOut } from 'lucide-react';

export default function AppLayout({ user }) {
  const location = useLocation();

  const handleLogout = () => {
    signOut(auth);
  };

  const navItems = [
    { name: 'Dashboard', path: '/', icon: LayoutDashboard },
    { name: 'Doctors Directory', path: '/doctors', icon: Users },
    { name: 'Medicines', path: '/medicines', icon: Pill },
    { name: 'Lab Tests', path: '/tests', icon: Activity },
  ];

  return (
    <div className="flex h-screen bg-background text-textMain">
      {/* Sidebar */}
      <aside className="w-64 bg-surface border-r border-borderLight flex flex-col justify-between">
        <div>
          <div className="p-6">
             <h1 className="text-2xl font-bold text-primary flex items-center gap-2">
                <Activity className="h-6 w-6" /> Tandrusti
             </h1>
             <p className="text-sm text-textMuted mt-1">Admin Dashboard</p>
          </div>

          <nav className="mt-6">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = location.pathname === item.path;
              return (
                <Link
                  key={item.name}
                  to={item.path}
                  className={`flex items-center px-6 py-3 border-l-4 transition-colors ${
                    isActive
                      ? 'border-primary bg-primary/10 text-primary font-bold'
                      : 'border-transparent text-textMuted hover:bg-background hover:text-textMain'
                  }`}
                >
                  <Icon className="w-5 h-5 mr-3" />
                  {item.name}
                </Link>
              );
            })}
          </nav>
        </div>

        <div className="p-6 border-t border-borderLight">
           <div className="flex items-center justify-between">
              <div className="text-sm truncate mr-2">
                <p className="font-bold truncate" title={user.email}>{user.email}</p>
                <p className="text-textMuted text-xs">Admin</p>
              </div>
              <button 
                onClick={handleLogout}
                className="p-2 text-textMuted hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                title="Log out"
              >
                <LogOut className="w-5 h-5" />
              </button>
           </div>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 overflow-y-auto">
        <header className="bg-surface border-b border-borderLight p-6">
           <h2 className="text-xl font-semibold capitalize text-textMain">
              {location.pathname === '/' ? 'Overview' : location.pathname.substring(1)}
           </h2>
        </header>

        <div className="p-8">
           <Outlet />
        </div>
      </main>
    </div>
  );
}
