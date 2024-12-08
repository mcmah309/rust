part of 'option.dart';

extension Option$RecordOption2Extension<A, B> on (Option<A>, Option<B>) {
  Option<(A, B)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    return Some((a, b));
  }
}

extension Option$RecordOption3Extension<A, B, C> on (Option<A>, Option<B>, Option<C>) {
  Option<(A, B, C)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    return Some((a, b, c));
  }
}

extension Option$RecordOption4Extension<A, B, C, D> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>
) {
  Option<(A, B, C, D)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    return Some((a, b, c, d));
  }
}

extension Option$RecordOption5Extension<A, B, C, D, E> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>
) {
  Option<(A, B, C, D, E)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e));
  }
}

extension Option$RecordOption6Extension<A, B, C, D, E, F> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>
) {
  Option<(A, B, C, D, E, F)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6;
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f));
  }
}

extension Option$RecordOption7Extension<A, B, C, D, E, F, G> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>
) {
  Option<(A, B, C, D, E, F, G)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6;
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7;
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g));
  }
}

extension Option$RecordOption8Extension<A, B, C, D, E, F, G, H> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>
) {
  Option<(A, B, C, D, E, F, G, H)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6;
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7;
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8;
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h));
  }
}

extension Option$RecordOption9Extension<A, B, C, D, E, F, G, H, I> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>
) {
  Option<(A, B, C, D, E, F, G, H, I)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6;
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7;
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8;
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    final iOpt = $9;
    final I i;
    switch (iOpt) {
      case Some(:final v):
        i = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h, i));
  }
}

extension Option$RecordOption10Extension<A, B, C, D, E, F, G, H, I, J> on (
  Option<A>,
  Option<B>,
  Option<C>,
  Option<D>,
  Option<E>,
  Option<F>,
  Option<G>,
  Option<H>,
  Option<I>,
  Option<J>
) {
  Option<(A, B, C, D, E, F, G, H, I, J)> toOption() {
    final aOpt = $1;
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2;
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3;
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4;
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5;
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6;
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7;
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8;
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    final iOpt = $9;
    final I i;
    switch (iOpt) {
      case Some(:final v):
        i = v;
      case _:
        return None;
    }
    final jOpt = $10;
    final J j;
    switch (jOpt) {
      case Some(:final v):
        j = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h, i, j));
  }
}

//************************************************************************//

extension Option$RecordOptionFunction2Extension<A, B> on (
  Option<A> Function(),
  Option<B> Function()
) {
  Option<(A, B)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    return Some((a, b));
  }
}

extension Option$RecordOptionFunction3Extension<A, B, C> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function()
) {
  Option<(A, B, C)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    return Some((a, b, c));
  }
}

extension Option$RecordOptionFunction4Extension<A, B, C, D> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function()
) {
  Option<(A, B, C, D)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    return Some((a, b, c, d));
  }
}

extension Option$RecordOptionFunction5Extension<A, B, C, D, E> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function()
) {
  Option<(A, B, C, D, E)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e));
  }
}

extension Option$RecordOptionFunction6Extension<A, B, C, D, E, F> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function()
) {
  Option<(A, B, C, D, E, F)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6();
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f));
  }
}

extension Option$RecordOptionFunction7Extension<A, B, C, D, E, F, G> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function()
) {
  Option<(A, B, C, D, E, F, G)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6();
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7();
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g));
  }
}

extension Option$RecordOptionFunction8Extension<A, B, C, D, E, F, G, H> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function()
) {
  Option<(A, B, C, D, E, F, G, H)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6();
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7();
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8();
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h));
  }
}

extension Option$RecordOptionFunction9Extension<A, B, C, D, E, F, G, H, I> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function(),
  Option<I> Function()
) {
  Option<(A, B, C, D, E, F, G, H, I)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6();
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7();
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8();
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    final iOpt = $9();
    final I i;
    switch (iOpt) {
      case Some(:final v):
        i = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h, i));
  }
}

extension Option$RecordOptionFunction10Extension<A, B, C, D, E, F, G, H, I, J> on (
  Option<A> Function(),
  Option<B> Function(),
  Option<C> Function(),
  Option<D> Function(),
  Option<E> Function(),
  Option<F> Function(),
  Option<G> Function(),
  Option<H> Function(),
  Option<I> Function(),
  Option<J> Function()
) {
  Option<(A, B, C, D, E, F, G, H, I, J)> toOption() {
    final aOpt = $1();
    final A a;
    switch (aOpt) {
      case Some(:final v):
        a = v;
      case _:
        return None;
    }
    final bOpt = $2();
    final B b;
    switch (bOpt) {
      case Some(:final v):
        b = v;
      case _:
        return None;
    }
    final cOpt = $3();
    final C c;
    switch (cOpt) {
      case Some(:final v):
        c = v;
      case _:
        return None;
    }
    final dOpt = $4();
    final D d;
    switch (dOpt) {
      case Some(:final v):
        d = v;
      case _:
        return None;
    }
    final eOpt = $5();
    final E e;
    switch (eOpt) {
      case Some(:final v):
        e = v;
      case _:
        return None;
    }
    final fOpt = $6();
    final F f;
    switch (fOpt) {
      case Some(:final v):
        f = v;
      case _:
        return None;
    }
    final gOpt = $7();
    final G g;
    switch (gOpt) {
      case Some(:final v):
        g = v;
      case _:
        return None;
    }
    final hOpt = $8();
    final H h;
    switch (hOpt) {
      case Some(:final v):
        h = v;
      case _:
        return None;
    }
    final iOpt = $9();
    final I i;
    switch (iOpt) {
      case Some(:final v):
        i = v;
      case _:
        return None;
    }
    final jOpt = $10();
    final J j;
    switch (jOpt) {
      case Some(:final v):
        j = v;
      case _:
        return None;
    }
    return Some((a, b, c, d, e, f, g, h, i, j));
  }
}