/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        summer: {
          orange: '#FF8C42',
          orangeLight: '#FFB366',
          orangeDark: '#E6731A',
          orangeAccent: '#FF6B35',
          offWhite: '#FEFCFB',
          cream: '#FFF8F3',
          warmGray: '#F5F3F0',
          dark: '#2D2D2D',
          charcoal: '#1A1A1A',
          text: '#3A3A3A',
          muted: '#6B6B6B'
        }
      },
      fontFamily: {
        'summer-bold': ['Inter', 'system-ui', 'sans-serif'],
        'summer-regular': ['Inter', 'system-ui', 'sans-serif'],
        'pretendard': ['Pretendard', 'system-ui', 'sans-serif'],
        'noto-kr': ['Noto Serif KR', 'serif']
      },
      fontWeight: {
        'summer-bold': '700',
        'summer-regular': '400',
        'summer-medium': '500'
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.4s ease-out',
        'bounce-gentle': 'bounceGentle 0.6s ease-out',
        'scale-in': 'scaleIn 0.3s ease-out'
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' }
        },
        bounceGentle: {
          '0%, 20%, 50%, 80%, 100%': { transform: 'translateY(0)' },
          '40%': { transform: 'translateY(-4px)' },
          '60%': { transform: 'translateY(-2px)' }
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' }
        }
      }
    },
  },
  plugins: [],
};