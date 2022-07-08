module Foreign.ReactIcons where

import Prim.Row (class Union)
import React.Basic (JSX, ReactComponent, element)
import React.Basic.DOM.Internal (SharedSVGProps)
import Unsafe.Coerce (unsafeCoerce)

type ReactIcon = ReactComponent (Record PropsIcon)

foreign import tbSignature_ :: ReactIcon
foreign import faGithub_ :: ReactIcon
foreign import faTwitter_ :: ReactIcon

type PropsIcon = SharedSVGProps
  ( children :: JSX
  , size :: String
  , color :: String
  , title :: String
  )

faGithub :: forall a b. Union a b PropsIcon => Record a -> JSX
faGithub = element faGithub'

faGithub' :: forall a b. Union a b PropsIcon => ReactComponent (Record a)
faGithub' = unsafeCoerce faGithub_

faTwitter :: forall a b. Union a b PropsIcon => Record a -> JSX
faTwitter = element faTwitter'

faTwitter' :: forall a b. Union a b PropsIcon => ReactComponent (Record a)
faTwitter' = unsafeCoerce faTwitter_

tbSignature :: forall a b. Union a b PropsIcon => Record a -> JSX
tbSignature = element tbSignature'

tbSignature' :: forall a b. Union a b PropsIcon => ReactComponent (Record a)
tbSignature' = unsafeCoerce tbSignature_
