%% Copyright (C) 2014-2016 Andrés Prieto
%% Copyright (C) 2015-2016 Colin Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @documentencoding UTF-8
%% @defmethod  @@sym ilaplace (@var{G}, @var{s}, @var{t})
%% @defmethodx @@sym ilaplace (@var{G})
%% @defmethodx @@sym ilaplace (@var{G}, @var{t})
%% Inverse Laplace transform.
%%
%% The inverse Laplace transform of a function @var{G} of @var{s}
%% is a function @var{f} of @var{t} defined by the integral below.
%% @example
%% @group
%% syms g(s) t
%% f(t) = rewrite(ilaplace(g), 'Integral')
%%   @result{} f(t) = (symfun)
%%           c + ∞⋅ⅈ
%%              ⌠
%%              ⎮          s⋅t
%%              ⎮    g(s)⋅ℯ    ds
%%              ⌡
%%           c - ∞⋅ⅈ
%% @end group
%% @end example
%%
%% Example:
%% @example
%% @group
%% syms s
%% F = 1/s^2;
%% ilaplace(F)
%%   @result{} (sym) t
%% @end group
%% @end example
%%
%% By default the ouput is a function of @code{t} (or @code{x} if the
%% inverse transform happens to be with respect to @code{t}).  This can
%% be overriden by specifying @var{t}.  For example:
%% @example
%% @group
%% syms s t x
%% ilaplace(1/s^2)
%%   @result{} (sym) t
%% ilaplace(1/t^2)
%%   @result{} (sym) x
%% ilaplace(1/s^2, x)
%%   @result{} (sym) x
%% @end group
%% @end example
%%
%% @seealso{@@sym/laplace}
%% @end defmethod

%% Author: Colin B. Macdonald, Andrés Prieto
%% Keywords: symbolic, integral transforms

function f = ilaplace(varargin)

  % FIXME: it only works for scalar functions

  % If the Laplace variable in the frequency domain is equal to "t",
  % "x" will be the physical variable (analogously to SMT)
  if (nargin == 1)
    F = sym(varargin{1});
    s = symvar(F, 1);  % note SMT does something different, prefers s
    if (isempty(s))
      s = sym('s');
    end
    cmd = { 'F=_ins[0]; s=_ins[1]; t=sp.Symbol("t")'
            'if t==s:'
            '    t=sp.Symbol("x", positive=True)'
            'f=0; a_ = sp.Wild("a_"); b_ = sp.Wild("b_")'
            'Fr=F.rewrite(sp.exp)'
            'if type(Fr)==sp.Add:'
            '    terms=Fr.expand().args'
            'else:'
            '    terms=(Fr,)'
            'for term in terms:'
            '    #compute the Laplace transform for each term'
            '    r=sp.simplify(term).match(a_*sp.exp(b_))'
            '    if r!=None and sp.diff(term,s)!=0:'
            '        modulus=r[a_]'
            '        phase=r[b_]/s'
            '        # if a is constant and b/s is constant'
            '        if sp.diff(modulus,s)==0 and sp.diff(phase,s)==0:'
            '            f = f + modulus*sp.DiracDelta(t+phase)'
            '        else:'
            '            f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            '    elif sp.diff(term,s)==0:'
            '        f = f + term*sp.DiracDelta(t)'
            '    else:'
            '        f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            'return f,'};

    f = python_cmd(cmd,F,s);

  elseif (nargin == 2)
    F = sym(varargin{1});
    t = sym(varargin{2});
    s = symvar(F, 1);  % note SMT does something different, prefers s
    if (isempty(s))
      s = sym('s');
    end
    cmd = { 'F=_ins[0]; s=_ins[1]; t=_ins[2]'
            'f=0; a_ = sp.Wild("a_"); b_ = sp.Wild("b_")'
            'Fr=F.rewrite(sp.exp)'
            'if type(Fr)==sp.Add:'
            '    terms=Fr.expand().args'
            'else:'
            '    terms=(Fr,)'
            'for term in terms:'
            '    #compute the Laplace transform for each term'
            '    r=sp.simplify(term).match(a_*sp.exp(b_))'
            '    if r!=None and sp.diff(term,s)!=0:'
            '        modulus=r[a_]'
            '        phase=r[b_]/s'
            '        # if a is constant and b/s is constant'
            '        if sp.diff(modulus,s)==0 and sp.diff(phase,s)==0:'
            '            f = f + modulus*sp.DiracDelta(t+phase)'
            '        else:'
            '            f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            '    elif sp.diff(term,s)==0:'
            '        f = f + term*sp.DiracDelta(t)'
            '    else:'
            '        f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            'return f,'};

    f = python_cmd(cmd,F,s,t);

  elseif (nargin == 3)
    F = sym(varargin{1});
    s = sym(varargin{2});
    t = sym(varargin{3});
    cmd = { 'F=_ins[0]; s=_ins[1]; t=_ins[2]'
            'f=0; a_ = sp.Wild("a_"); b_ = sp.Wild("b_")'
            'Fr=F.rewrite(sp.exp)'
            'if type(Fr)==sp.Add:'
            '    terms=Fr.expand().args'
            'else:'
            '    terms=(Fr,)'
            'for term in terms:'
            '    #compute the Laplace transform for each term'
            '    r=sp.simplify(term).match(a_*sp.exp(b_))'
            '    if r!=None and sp.diff(term,s)!=0:'
            '        modulus=r[a_]'
            '        phase=r[b_]/s'
            '        # if a is constant and b/s is constant'
            '        if sp.diff(modulus,s)==0 and sp.diff(phase,s)==0:'
            '            f = f + modulus*sp.DiracDelta(t+phase)'
            '        else:'
            '            f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            '    elif sp.diff(term,s)==0:'
            '        f = f + term*sp.DiracDelta(t)'
            '    else:'
            '        f = f + sp.Subs(sp.inverse_laplace_transform(term, s, t),sp.Heaviside(t),1).doit()'
            'return f,'};

    f = python_cmd(cmd,F,s,t);

  else
    print_usage ();

  end

end


%!test
%! % basic
%! syms s t
%! assert(logical( ilaplace(1/s^2) == t ))
%! assert(logical( ilaplace(s/(s^2+9)) == cos(3*t) ))

%!test
%! % SMT compact
%! syms r s t u
%! assert(logical( ilaplace(1/r^2,u) == u ))
%! assert(logical( ilaplace(1/r^2,r,u) == u ))
%! assert(logical( ilaplace(s/(s^2+9)) == cos(3*t) ))
%! assert(logical( ilaplace(6/s^4) == t^3 ))

%!test
%! % Heaviside test
%! syms s
%! t=sym('t', 'positive');
%! assert(logical( ilaplace(exp(-5*s)/s^2,t) == (t-5)*heaviside(t-5) ))

%!test
%! % Delta dirac tests
%! syms s c
%! t=sym('t','positive');
%! assert(logical( ilaplace(sym('2'),t) == 2*dirac(t) ))
%! assert(logical( ilaplace(5*exp(-3*s)+2*exp(c*s)-2*exp(-2*s)/s,t) == 5*dirac(t-3)+2*dirac(c+t)-2*heaviside(t-2)))
